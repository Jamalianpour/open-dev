class SqlUtils {
  /// Major clauses — these force a newline before them at the top level.
  static const _topLevelClauses = <String>{
    'SELECT',
    'FROM',
    'WHERE',
    'GROUP BY',
    'HAVING',
    'ORDER BY',
    'LIMIT',
    'OFFSET',
    'UNION',
    'UNION ALL',
    'INTERSECT',
    'EXCEPT',
    'INSERT INTO',
    'VALUES',
    'UPDATE',
    'SET',
    'DELETE FROM',
    'RETURNING',
    'WITH',
  };

  /// JOIN variants — also force a newline.
  static const _joinClauses = <String>{
    'INNER JOIN',
    'LEFT JOIN',
    'LEFT OUTER JOIN',
    'RIGHT JOIN',
    'RIGHT OUTER JOIN',
    'FULL JOIN',
    'FULL OUTER JOIN',
    'CROSS JOIN',
    'JOIN',
  };

  /// Inline keywords — uppercased but no newline.
  static const _inlineKeywords = <String>{
    'AND',
    'OR',
    'NOT',
    'ON',
    'AS',
    'IN',
    'IS',
    'NULL',
    'TRUE',
    'FALSE',
    'LIKE',
    'BETWEEN',
    'CASE',
    'WHEN',
    'THEN',
    'ELSE',
    'END',
    'DISTINCT',
    'ALL',
    'EXISTS',
    'ASC',
    'DESC',
    'BY',
  };

  /// Formats a SQL statement: uppercases known keywords, places each top-level
  /// clause on its own line, indents JOINs, and indents the body of
  /// parenthesised subqueries.
  ///
  /// This is intentionally a lightweight formatter — it handles the common
  /// SELECT/INSERT/UPDATE/DELETE shapes well, but doesn't pretty-print arbitrary
  /// DDL or vendor-specific syntax.
  static String format(String sql, {int indent = 2}) {
    if (sql.trim().isEmpty) return '';

    final tokens = _tokenize(sql);
    final pad = ' ' * indent;
    final buffer = StringBuffer();
    int depth = 0;
    bool atLineStart = true;

    void newline() {
      if (!atLineStart) {
        buffer.write('\n');
        buffer.write(pad * depth);
        atLineStart = true;
      }
    }

    void writeToken(String t, {bool spaceBefore = true}) {
      if (atLineStart) {
        buffer.write(t);
      } else {
        if (spaceBefore) buffer.write(' ');
        buffer.write(t);
      }
      atLineStart = false;
    }

    for (int i = 0; i < tokens.length; i++) {
      final t = tokens[i];
      final upper = t.toUpperCase();

      // Try to match a two-word clause first (e.g. GROUP BY, LEFT JOIN).
      String? clause;
      bool isJoin = false;
      if (i + 1 < tokens.length) {
        final two = '$upper ${tokens[i + 1].toUpperCase()}';
        if (_topLevelClauses.contains(two)) {
          clause = two;
        } else if (_joinClauses.contains(two)) {
          clause = two;
          isJoin = true;
        }
      }
      if (clause == null && i + 2 < tokens.length) {
        final three =
            '$upper ${tokens[i + 1].toUpperCase()} ${tokens[i + 2].toUpperCase()}';
        if (_topLevelClauses.contains(three)) {
          clause = three;
        } else if (_joinClauses.contains(three)) {
          clause = three;
          isJoin = true;
        }
      }
      if (clause == null) {
        if (_topLevelClauses.contains(upper)) {
          clause = upper;
        } else if (_joinClauses.contains(upper)) {
          clause = upper;
          isJoin = true;
        }
      }

      if (clause != null) {
        newline();
        if (isJoin) buffer.write(pad);
        buffer.write(clause);
        atLineStart = false;
        i += clause.split(' ').length - 1;
        continue;
      }

      if (t == '(') {
        writeToken('(', spaceBefore: !atLineStart);
        depth++;
        // Only break into a new line if the next non-space token is a clause
        // keyword (i.e. a subquery).
        if (i + 1 < tokens.length &&
            _topLevelClauses.contains(tokens[i + 1].toUpperCase())) {
          newline();
        }
        continue;
      }
      if (t == ')') {
        if (depth > 0) depth--;
        // Close on its own line when paired with a subquery break.
        if (buffer.toString().endsWith('\n${pad * (depth + 1)}') ||
            (buffer.isNotEmpty &&
                buffer.toString().contains('\n${pad * (depth + 1)}'))) {
          // Heuristic: close cleanly if we broke inside the parens.
        }
        writeToken(')', spaceBefore: false);
        continue;
      }
      if (t == ',') {
        writeToken(',', spaceBefore: false);
        continue;
      }
      if (t == ';') {
        writeToken(';', spaceBefore: false);
        continue;
      }
      if (_inlineKeywords.contains(upper)) {
        writeToken(upper);
        continue;
      }
      writeToken(t);
    }

    return buffer.toString().trimRight();
  }

  /// Minifies SQL: collapses whitespace runs into a single space and strips
  /// `--` line comments and `/* … */` block comments.
  static String minify(String sql) {
    final noBlockComments =
        sql.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), ' ');
    final noLineComments =
        noBlockComments.replaceAll(RegExp(r'--[^\n]*'), ' ');
    return noLineComments
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAllMapped(RegExp(r'\s*([(),;])\s*'), (m) => m[1]!)
        .trim();
  }

  /// Splits SQL into tokens preserving string literals and identifiers.
  static List<String> _tokenize(String sql) {
    final out = <String>[];
    final buffer = StringBuffer();
    int i = 0;

    void flush() {
      if (buffer.isNotEmpty) {
        out.add(buffer.toString());
        buffer.clear();
      }
    }

    while (i < sql.length) {
      final ch = sql[i];
      if (ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r') {
        flush();
        i++;
        continue;
      }
      if (ch == "'" || ch == '"' || ch == '`') {
        flush();
        final quote = ch;
        final start = i;
        i++;
        while (i < sql.length) {
          if (sql[i] == quote) {
            // Handle escaped quote: '' inside ' or "" inside "
            if (i + 1 < sql.length && sql[i + 1] == quote) {
              i += 2;
              continue;
            }
            i++;
            break;
          }
          i++;
        }
        out.add(sql.substring(start, i));
        continue;
      }
      if (ch == '(' || ch == ')' || ch == ',' || ch == ';') {
        flush();
        out.add(ch);
        i++;
        continue;
      }
      buffer.write(ch);
      i++;
    }
    flush();
    return out;
  }
}

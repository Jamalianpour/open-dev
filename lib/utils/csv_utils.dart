import 'dart:convert';

class CsvUtils {
  /// Parses a CSV document into a list of rows (each row a list of cell
  /// strings). Supports RFC-4180 style quoting:
  ///
  /// * Fields can be wrapped in `"..."` to include the delimiter or newlines.
  /// * `""` inside a quoted field is a literal `"`.
  ///
  /// The default [delimiter] is `,`. Pass `;` or `\t` for TSV / semicolon CSV.
  static List<List<String>> parse(String input, {String delimiter = ','}) {
    final rows = <List<String>>[];
    if (input.isEmpty) return rows;

    final List<String> row = [];
    final StringBuffer cell = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < input.length; i++) {
      final ch = input[i];
      if (inQuotes) {
        if (ch == '"') {
          if (i + 1 < input.length && input[i + 1] == '"') {
            cell.write('"');
            i++;
          } else {
            inQuotes = false;
          }
        } else {
          cell.write(ch);
        }
      } else {
        if (ch == '"') {
          inQuotes = true;
        } else if (ch == delimiter) {
          row.add(cell.toString());
          cell.clear();
        } else if (ch == '\n') {
          row.add(cell.toString());
          cell.clear();
          rows.add(List<String>.from(row));
          row.clear();
        } else if (ch == '\r') {
          // Swallow; \r\n is handled when \n arrives.
        } else {
          cell.write(ch);
        }
      }
    }
    // Flush final cell/row if input doesn't end with newline.
    if (cell.isNotEmpty || row.isNotEmpty) {
      row.add(cell.toString());
      rows.add(row);
    }
    return rows;
  }

  /// Converts CSV (with header row) into a pretty-printed JSON array of
  /// objects.
  static String csvToJson(String csv, {String delimiter = ','}) {
    final rows = parse(csv, delimiter: delimiter);
    if (rows.isEmpty) return '[]';
    final headers = rows.first;
    final data = <Map<String, dynamic>>[];
    for (int i = 1; i < rows.length; i++) {
      final r = rows[i];
      if (r.length == 1 && r.first.isEmpty) continue;
      final m = <String, dynamic>{};
      for (int c = 0; c < headers.length; c++) {
        m[headers[c]] = c < r.length ? _coerce(r[c]) : null;
      }
      data.add(m);
    }
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Best-effort scalar coercion: numbers and booleans become typed.
  static dynamic _coerce(String value) {
    if (value.isEmpty) return '';
    final lower = value.toLowerCase();
    if (lower == 'true') return true;
    if (lower == 'false') return false;
    if (lower == 'null') return null;
    final i = int.tryParse(value);
    if (i != null) return i;
    final d = double.tryParse(value);
    if (d != null) return d;
    return value;
  }

  /// Converts a JSON array of flat objects into CSV. Keys from the first
  /// object define the column order; missing keys in later rows are blank.
  static String jsonToCsv(String jsonString, {String delimiter = ','}) {
    final decoded = jsonDecode(jsonString);
    if (decoded is! List) {
      throw const FormatException('JSON root must be an array of objects');
    }
    if (decoded.isEmpty) return '';
    final headers = <String>[];
    for (final row in decoded) {
      if (row is! Map) {
        throw const FormatException('JSON array must contain objects');
      }
      for (final k in row.keys) {
        if (!headers.contains(k.toString())) headers.add(k.toString());
      }
    }
    final buffer = StringBuffer();
    buffer.writeln(headers.map((h) => _escape(h, delimiter)).join(delimiter));
    for (final row in decoded) {
      final m = row as Map;
      final cells = headers.map((h) {
        final v = m[h];
        return _escape(v?.toString() ?? '', delimiter);
      }).join(delimiter);
      buffer.writeln(cells);
    }
    return buffer.toString();
  }

  static String _escape(String value, String delimiter) {
    final needsQuotes = value.contains(delimiter) ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r');
    if (!needsQuotes) return value;
    return '"${value.replaceAll('"', '""')}"';
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:open_dev/utils/sql_utils.dart';

void main() {
  group('SqlUtils.format', () {
    test('returns empty string for empty input', () {
      expect(SqlUtils.format(''), '');
      expect(SqlUtils.format('   '), '');
    });

    test('uppercases keywords and puts each major clause on its own line', () {
      final out = SqlUtils.format(
          'select id, name from users where id > 10 order by name');
      final lines = out.split('\n');
      expect(lines.any((l) => l.startsWith('SELECT')), isTrue);
      expect(lines.any((l) => l.startsWith('FROM')), isTrue);
      expect(lines.any((l) => l.startsWith('WHERE')), isTrue);
      expect(lines.any((l) => l.startsWith('ORDER BY')), isTrue);
    });

    test('uppercases inline keywords without breaking the line', () {
      final out = SqlUtils.format('select * from t where a and b or c');
      expect(out.contains('AND'), isTrue);
      expect(out.contains('OR'), isTrue);
    });

    test('preserves string literals', () {
      final out = SqlUtils.format("select * from u where name = 'Ada'");
      expect(out.contains("'Ada'"), isTrue);
    });

    test('handles JOINs', () {
      final out = SqlUtils.format(
          'select * from a left join b on a.id = b.a_id inner join c on c.b_id = b.id');
      expect(out.contains('LEFT JOIN'), isTrue);
      expect(out.contains('INNER JOIN'), isTrue);
    });
  });

  group('SqlUtils.minify', () {
    test('collapses whitespace runs', () {
      expect(SqlUtils.minify('SELECT  *   FROM   t'), 'SELECT * FROM t');
    });

    test('strips line comments', () {
      expect(SqlUtils.minify('SELECT * -- a comment\nFROM t'),
          'SELECT * FROM t');
    });

    test('strips block comments', () {
      expect(SqlUtils.minify('SELECT /* keep */ * FROM t'),
          'SELECT * FROM t');
    });

    test('strips spaces around punctuation', () {
      expect(SqlUtils.minify('SELECT a , b FROM t ; '),
          'SELECT a,b FROM t;');
    });
  });
}

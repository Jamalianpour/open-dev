import 'package:flutter_test/flutter_test.dart';
import 'package:open_dev/utils/csv_utils.dart';

void main() {
  group('CsvUtils.parse', () {
    test('parses simple comma-separated rows', () {
      final rows = CsvUtils.parse('a,b,c\n1,2,3');
      expect(rows.length, 2);
      expect(rows[0], ['a', 'b', 'c']);
      expect(rows[1], ['1', '2', '3']);
    });

    test('handles quoted fields with commas', () {
      final rows = CsvUtils.parse('name,note\nAda,"hello, world"');
      expect(rows[1], ['Ada', 'hello, world']);
    });

    test('handles escaped quotes inside quoted fields', () {
      final rows = CsvUtils.parse('name,note\nAda,"she said ""hi"""');
      expect(rows[1], ['Ada', 'she said "hi"']);
    });

    test('handles newlines inside quoted fields', () {
      final rows = CsvUtils.parse('a,b\n"line1\nline2",x');
      expect(rows[1], ['line1\nline2', 'x']);
    });

    test('honors alternative delimiters', () {
      final rows = CsvUtils.parse('a;b;c\n1;2;3', delimiter: ';');
      expect(rows[1], ['1', '2', '3']);
    });
  });

  group('CsvUtils.csvToJson', () {
    test('uses first row as headers and coerces scalars', () {
      final json = CsvUtils.csvToJson('a,b,c\n1,true,hi');
      expect(json.contains('"a": 1'), isTrue);
      expect(json.contains('"b": true'), isTrue);
      expect(json.contains('"c": "hi"'), isTrue);
    });

    test('returns [] for empty input', () {
      expect(CsvUtils.csvToJson(''), '[]');
    });
  });

  group('CsvUtils.jsonToCsv', () {
    test('writes headers and rows', () {
      final csv = CsvUtils.jsonToCsv('[{"a":1,"b":2},{"a":3,"b":4}]');
      expect(csv.split('\n').first, 'a,b');
      expect(csv.contains('1,2'), isTrue);
      expect(csv.contains('3,4'), isTrue);
    });

    test('escapes cells containing the delimiter', () {
      final csv = CsvUtils.jsonToCsv('[{"x":"hello, world"}]');
      expect(csv.contains('"hello, world"'), isTrue);
    });

    test('escapes embedded quotes by doubling them', () {
      final csv = CsvUtils.jsonToCsv('[{"x":"she said \\"hi\\""}]');
      expect(csv.contains('"she said ""hi"""'), isTrue);
    });

    test('rejects non-array JSON', () {
      expect(
          () => CsvUtils.jsonToCsv('{"not":"array"}'), throwsFormatException);
    });
  });
}

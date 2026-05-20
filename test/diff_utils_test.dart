import 'package:flutter_test/flutter_test.dart';
import 'package:open_dev/utils/diff_utils.dart';

void main() {
  group('DiffUtils.lineDiff', () {
    test('returns empty diff for two empty strings', () {
      expect(DiffUtils.lineDiff('', ''), isEmpty);
    });

    test('marks all lines equal when inputs match', () {
      final d = DiffUtils.lineDiff('a\nb\nc', 'a\nb\nc');
      expect(d.length, 3);
      expect(d.every((l) => l.op == DiffOp.equal), isTrue);
      expect(d.map((l) => l.leftLineNo).toList(), [1, 2, 3]);
      expect(d.map((l) => l.rightLineNo).toList(), [1, 2, 3]);
    });

    test('detects single-line insert', () {
      final d = DiffUtils.lineDiff('a\nc', 'a\nb\nc');
      expect(d.length, 3);
      expect(d[0].op, DiffOp.equal);
      expect(d[1].op, DiffOp.insert);
      expect(d[1].text, 'b');
      expect(d[1].leftLineNo, isNull);
      expect(d[1].rightLineNo, 2);
      expect(d[2].op, DiffOp.equal);
    });

    test('detects single-line delete', () {
      final d = DiffUtils.lineDiff('a\nb\nc', 'a\nc');
      final del = d.firstWhere((l) => l.op == DiffOp.delete);
      expect(del.text, 'b');
      expect(del.rightLineNo, isNull);
      expect(del.leftLineNo, 2);
    });

    test('handles complete replacement', () {
      final d = DiffUtils.lineDiff('a\nb', 'c\nd');
      final stats = DiffUtils.stats(d);
      expect(stats.added, 2);
      expect(stats.removed, 2);
      expect(stats.unchanged, 0);
    });

    test('stats counts each operation kind', () {
      final d = DiffUtils.lineDiff('a\nb\nc', 'a\nx\nc\nd');
      final s = DiffUtils.stats(d);
      expect(s.unchanged, 2); // a and c
      expect(s.removed, 1); // b
      expect(s.added, 2); // x and d
    });
  });
}

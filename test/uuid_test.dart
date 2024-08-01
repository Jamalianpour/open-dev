import 'package:flutter_test/flutter_test.dart';
import 'package:open_dev/utils/uuid_utils.dart';

void main() {
  group('UuidUtils.decode', () {
    test('should decode a valid UUID', () {
      var uuid = UuidUtils.generateV1();
      var result = UuidUtils.decode(uuid);

      expect(result.$1, 1);
      expect(result.$2, '2 (Microsoft\'s GUIDs)');
      expect(result.$3 >= 0, true);
      expect(result.$4 >= 0, true);
      expect(result.$5.split(':').length, 6);
    });

    test('should handle invalid UUIDs', () {
      expect(() => UuidUtils.decode('invalid'), throwsA(isA<FormatException>()));
    });
  });
}
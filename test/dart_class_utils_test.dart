import 'package:flutter_test/flutter_test.dart';
import 'package:open_dev/utils/dart_class_utils.dart';

void main() {
  group('DartClassUtils.generate', () {
    test('generates a single class for a flat object', () {
      final out = DartClassUtils.generate(
          '{"id": 1, "name": "Ada", "active": true}',
          rootName: 'User');
      expect(out.contains('class User {'), isTrue);
      expect(out.contains('final int? id;'), isTrue);
      expect(out.contains('final String? name;'), isTrue);
      expect(out.contains('final bool? active;'), isTrue);
      expect(out.contains('factory User.fromJson'), isTrue);
      expect(out.contains('Map<String, dynamic> toJson()'), isTrue);
    });

    test('nests classes for nested objects', () {
      final out = DartClassUtils.generate(
          '{"address": {"city": "Paris"}}',
          rootName: 'Root');
      expect(out.contains('class Root {'), isTrue);
      expect(out.contains('class Address {'), isTrue);
      expect(out.contains('final Address? address;'), isTrue);
    });

    test('detects typed list of primitives', () {
      final out = DartClassUtils.generate('{"tags": ["a","b"]}');
      expect(out.contains('List<String>? tags'), isTrue);
    });

    test('detects typed list of objects', () {
      final out = DartClassUtils.generate(
          '{"friends": [{"id": 1}]}');
      expect(out.contains('List<Friends>? friends'), isTrue);
      expect(out.contains('class Friends {'), isTrue);
    });

    test('non-nullable + non-immutable mode toggles required + drops final',
        () {
      final out = DartClassUtils.generate('{"id": 1}',
          nullable: false, immutable: false);
      expect(out.contains('  int id;'), isTrue);
      expect(out.contains('final'), isFalse);
      expect(out.contains('required this.id'), isTrue);
    });

    test('renames identifiers to camelCase but preserves the JSON key', () {
      final out = DartClassUtils.generate('{"user_name": "x"}');
      expect(out.contains('String? userName'), isTrue);
      expect(out.contains("'user_name': userName"), isTrue);
    });

    test('rejects non-object root with a comment', () {
      final out = DartClassUtils.generate('[1, 2, 3]');
      expect(out.contains('not an object'), isTrue);
    });

    test('handles empty arrays as List<dynamic>', () {
      final out = DartClassUtils.generate('{"items": []}');
      expect(out.contains('List<dynamic>? items'), isTrue);
    });

    test('falls back to List<dynamic> for heterogeneous arrays', () {
      final out = DartClassUtils.generate('{"mixed": [1, "x", true]}');
      expect(out.contains('List<dynamic>? mixed'), isTrue);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:open_dev/utils/html_utils.dart';

void main() {
  group('HtmlUtils.encode', () {
    test('escapes basic element entities', () {
      expect(HtmlUtils.encode('<b>hi</b> & "ok"'),
          '&lt;b>hi&lt;/b> &amp; "ok"');
    });

    test('attribute mode also escapes quotes and slashes', () {
      final encoded = HtmlUtils.encodeForAttribute('a"b\'c/d');
      expect(encoded.contains('&quot;'), isTrue);
      expect(encoded.contains('&#47;'), isTrue);
    });
  });

  group('HtmlUtils.decode', () {
    test('decodes common named entities', () {
      expect(HtmlUtils.decode('&amp;&lt;&gt;&quot;&apos;&nbsp;'),
          '&<>"\' ');
    });

    test('decodes decimal numeric entities', () {
      expect(HtmlUtils.decode('&#60;&#62;'), '<>');
    });

    test('decodes hex numeric entities', () {
      expect(HtmlUtils.decode('&#x3C;&#x3E;'), '<>');
    });

    test('leaves unknown named entities untouched', () {
      expect(HtmlUtils.decode('&zzz;'), '&zzz;');
    });

    test('encode then decode is an identity round-trip', () {
      const original = '<p>Hello & "world" — café</p>';
      final encoded = HtmlUtils.encode(original);
      expect(HtmlUtils.decode(encoded), original);
    });
  });
}

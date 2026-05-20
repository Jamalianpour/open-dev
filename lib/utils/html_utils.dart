import 'dart:convert';

class HtmlUtils {
  static const _escape = HtmlEscape(HtmlEscapeMode.element);
  static const _attr = HtmlEscape(HtmlEscapeMode.attribute);

  /// Standard HTML escaping (for element content): < > & become entities.
  static String encode(String input) => _escape.convert(input);

  /// Aggressive escaping suitable for inside attribute values: also escapes
  /// quotes and slashes.
  static String encodeForAttribute(String input) => _attr.convert(input);

  /// Decodes named entities (e.g. `&amp;`), decimal entities (`&#60;`) and
  /// hex entities (`&#x3C;`). Unknown named entities are left intact.
  static String decode(String input) {
    return input.replaceAllMapped(
      RegExp(r'&(#x[0-9a-fA-F]+|#[0-9]+|[a-zA-Z][a-zA-Z0-9]+);'),
      (m) {
        final body = m[1]!;
        if (body.startsWith('#x') || body.startsWith('#X')) {
          final cp = int.tryParse(body.substring(2), radix: 16);
          if (cp == null) return m[0]!;
          return String.fromCharCode(cp);
        }
        if (body.startsWith('#')) {
          final cp = int.tryParse(body.substring(1));
          if (cp == null) return m[0]!;
          return String.fromCharCode(cp);
        }
        return _named[body] ?? m[0]!;
      },
    );
  }

  // Most common named entities. Full HTML5 named-entity table has 2000+; this
  // list covers everyday text. Unknown names are returned untouched by
  // [decode].
  static const Map<String, String> _named = {
    'amp': '&',
    'lt': '<',
    'gt': '>',
    'quot': '"',
    'apos': "'",
    'nbsp': ' ',
    'copy': '©',
    'reg': '®',
    'trade': '™',
    'hellip': '…',
    'mdash': '—',
    'ndash': '–',
    'lsquo': '‘',
    'rsquo': '’',
    'ldquo': '“',
    'rdquo': '”',
    'laquo': '«',
    'raquo': '»',
    'euro': '€',
    'pound': '£',
    'yen': '¥',
    'cent': '¢',
    'sect': '§',
    'para': '¶',
    'deg': '°',
    'plusmn': '±',
    'times': '×',
    'divide': '÷',
    'middot': '·',
    'bull': '•',
    'larr': '←',
    'uarr': '↑',
    'rarr': '→',
    'darr': '↓',
    'harr': '↔',
    'check': '✓',
    'cross': '✗',
  };
}

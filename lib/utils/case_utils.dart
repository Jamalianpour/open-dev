/// Splits an arbitrary identifier into its constituent words.
///
/// Handles camelCase, PascalCase, snake_case, kebab-case, dot.case,
/// path/case, SCREAMING_SNAKE, and free text with spaces/punctuation.
List<String> _tokens(String input) {
  if (input.isEmpty) return const [];
  final cleaned = input.replaceAll(RegExp(r'[_\-./\\\s]+'), ' ');
  final spaced = cleaned
      // Insert space between a lowercase/digit and an uppercase letter.
      .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      // Insert space between an acronym and a Word: HTTPRequest -> HTTP Request.
      .replaceAllMapped(
          RegExp(r'([A-Z]+)([A-Z][a-z])'), (m) => '${m[1]} ${m[2]}');
  return spaced
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .map((w) => w.toLowerCase())
      .toList();
}

String _cap(String w) =>
    w.isEmpty ? w : w[0].toUpperCase() + w.substring(1);

class CaseUtils {
  static String camel(String input) {
    final t = _tokens(input);
    if (t.isEmpty) return '';
    return t.first + t.skip(1).map(_cap).join();
  }

  static String pascal(String input) =>
      _tokens(input).map(_cap).join();

  static String snake(String input) => _tokens(input).join('_');

  static String screamingSnake(String input) =>
      _tokens(input).map((w) => w.toUpperCase()).join('_');

  static String kebab(String input) => _tokens(input).join('-');

  static String cobol(String input) =>
      _tokens(input).map((w) => w.toUpperCase()).join('-');

  static String dot(String input) => _tokens(input).join('.');

  static String path(String input) => _tokens(input).join('/');

  static String title(String input) =>
      _tokens(input).map(_cap).join(' ');

  static String sentence(String input) {
    final t = _tokens(input);
    if (t.isEmpty) return '';
    return _cap(t.first) + (t.length > 1 ? ' ${t.skip(1).join(' ')}' : '');
  }

  static String upper(String input) => input.toUpperCase();
  static String lower(String input) => input.toLowerCase();
}

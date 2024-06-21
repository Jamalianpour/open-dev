import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class RegexCheatSheet extends StatelessWidget {
  const RegexCheatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Regular Expressions (Regex) are sequences of characters that define a search pattern, mainly for use in pattern matching with strings.'),
            const Divider(),
            // Text('Basic Syntax', style: Theme.of(context).textTheme.titleMedium),
            MarkdownWidget(
              data: '''
### Basic Syntax
- `.` : Matches any single character except newline.
  - Example: `a.b` matches `aab`, `a7b`, `a_b`, etc.

- `^` : Matches the start of a string.
  - Example: `^abc` matches `abc` in `abcdef`, but not in `zabc`.

- `\$` : Matches the end of a string.
  - Example: `abc\$` matches `abc` in `defabc`, but not in `abcxyz`.

- `*` : Matches 0 or more repetitions of the preceding element.
  - Example: `ab*c` matches `ac`, `abc`, `abbc`, etc.

- `+` : Matches 1 or more repetitions of the preceding element.
  - Example: `ab+c` matches `abc`, `abbc`, `but` not `ac`.

- `?` : Matches 0 or 1 repetition of the preceding element.
  - Example: `ab?c` matches `ac`, `abc`, but not `abbc`.

- `{n}` : Matches exactly n repetitions of the preceding element.
  - Example: `a{3}` matches `aaa`.

- `{n,}` : Matches n or more repetitions of the preceding element.
  - Example: `a{2,}` matches `aa`, `aaa`, `aaaa`, etc.

- `{n,m}` : Matches between n and m repetitions of the preceding element.
  - Example: `a{2,4}` matches `aa`, `aaa`, or `aaaa`.

- `|` : Alternation (OR operator).
  - Example: `abc|def` matches `abc` or `def`.

- `()` : Groups expressions and creates capture groups.
  - Example: `(abc){2}` matches `abcabc`.

### Character Classes
- `[abc]` : Matches any one of the enclosed characters.
  - Example: `[abc]` matches `a`, `b`, or `c`.

- `[^abc]` : Matches any character not enclosed.
  - Example: `[^abc]` matches `d`, `e`, `f`, etc.

- `[a-z]` : Matches any character in the range.
  - Example: `[a-z]` matches any lowercase letter.

- `\\d` : Matches any digit (equivalent to [0-9]).
  - Example: `\\d` matches `0`, `1`, `2`, etc.

- `\\D` : Matches any non-digit.
  - Example: `\\D` matches `a`, `b`, `c`, etc.

- `\\w` : Matches any word character (alphanumeric + underscore).
  - Example: `\\w` matches `a`, `b`, `1`, `_`, etc.

- `\\W` : Matches any non-word character.
  - Example: `\\W` matches `@`, `%`, , etc.

- `\\s` : Matches any whitespace character.
  - Example: `\\s` matches ``, `\\t`, `\\n`, etc.

- `\\S` : Matches any non-whitespace character.
  - Example: `\\S` matches `a`, `1`, `@`, etc.

### Escape Sequences
- `\\` : Escapes a special character.
  - Example: `\\.` matches a literal period.

### Anchors
- `\\b` : Word boundary.
  - Example: `\\bword\\b` matches `word` in `a word` but not in `sword`.

- `\\B` : Non-word boundary.
  - Example: `\\Bword\\B` matches `swords`.

### Lookahead and Lookbehind
- `(?=...)` : Positive lookahead.
  - Example: `a(?=b)` matches `a` in `abc` but not in `ac`.

- `(?!...)` : Negative lookahead.
  - Example: a(?!b) matches `a` in `ac` but not in `abc`.

- `(?<=...)` : Positive lookbehind.
  - Example: `(?<=a)b` matches `b` in `ab` but not `cb`.

- `(?<!...)` : Negative lookbehind.
  - Example: `(?<!a)b` matches `b` in `cb` but not in `ab`.
''',
              shrinkWrap: true,
              config: MarkdownConfig(configs: [
                HrConfig.darkConfig,
                PreConfig.darkConfig,
                PConfig.darkConfig,
                CodeConfig.darkConfig,
                BlockquoteConfig.darkConfig,
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

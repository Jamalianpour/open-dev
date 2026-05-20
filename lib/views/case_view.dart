import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/case_utils.dart';
import 'package:open_dev/widgets/data_widget.dart';

class CaseView extends StatefulWidget {
  const CaseView({super.key});

  @override
  State<CaseView> createState() => _CaseViewState();
}

class _CaseViewState extends State<CaseView> {
  final TextEditingController _input =
      TextEditingController(text: 'hello world foo bar');

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  List<(String, String)> _outputs(String input) => [
        ('camelCase', CaseUtils.camel(input)),
        ('PascalCase', CaseUtils.pascal(input)),
        ('snake_case', CaseUtils.snake(input)),
        ('SCREAMING_SNAKE', CaseUtils.screamingSnake(input)),
        ('kebab-case', CaseUtils.kebab(input)),
        ('COBOL-CASE', CaseUtils.cobol(input)),
        ('dot.case', CaseUtils.dot(input)),
        ('path/case', CaseUtils.path(input)),
        ('Title Case', CaseUtils.title(input)),
        ('Sentence case', CaseUtils.sentence(input)),
        ('UPPERCASE', CaseUtils.upper(input)),
        ('lowercase', CaseUtils.lower(input)),
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('String Case Converter',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        const Divider(indent: 8, endIndent: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Input'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _input,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              gapPadding: 0),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        style: const TextStyle(fontFamily: 'monospace'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      tooltip: 'Clear',
                      onPressed: () {
                        _input.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        for (final entry in _outputs(_input.text))
                          DataWidget(
                            title: entry.$1,
                            value: entry.$2,
                            width: 340,
                            maxWidth: 340,
                            minWidth: 340,
                            textStyle: const TextStyle(
                                fontFamily: 'monospace', fontSize: 13),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final buffer = StringBuffer();
                      for (final e in _outputs(_input.text)) {
                        buffer.writeln('${e.$1}: ${e.$2}');
                      }
                      Clipboard.setData(
                          ClipboardData(text: buffer.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Copied all cases to clipboard'),
                            duration: Duration(seconds: 1)),
                      );
                    },
                    icon: const Icon(Icons.copy_all, size: 16),
                    label: const Text('Copy all'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

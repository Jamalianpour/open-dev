import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/sql_utils.dart';

class SqlView extends StatefulWidget {
  const SqlView({super.key});

  @override
  State<SqlView> createState() => _SqlViewState();
}

class _SqlViewState extends State<SqlView> {
  final TextEditingController _input =
      TextEditingController(text: '''select u.id, u.name, count(o.id) as orders from users u left join orders o on o.user_id = u.id where u.created_at > '2024-01-01' group by u.id, u.name having count(o.id) > 5 order by orders desc limit 10''');
  final TextEditingController _output = TextEditingController();
  int _indent = 2;

  @override
  void dispose() {
    _input.dispose();
    _output.dispose();
    super.dispose();
  }

  void _format() {
    setState(() {
      _output.text = SqlUtils.format(_input.text, indent: _indent);
    });
  }

  void _minify() {
    setState(() {
      _output.text = SqlUtils.minify(_input.text);
    });
  }

  Widget _panel({
    required String label,
    required TextEditingController controller,
    required bool readOnly,
    List<Widget> actions = const [],
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [Text(label), const Spacer(), ...actions],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: controller,
                readOnly: readOnly,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                    fontFamily: 'monospace', fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), gapPadding: 0),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Text('SQL Formatter',
                  style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              const Text('Indent: '),
              const SizedBox(width: 6),
              DropdownButton<int>(
                value: _indent,
                items: const [
                  DropdownMenuItem(value: 2, child: Text('2')),
                  DropdownMenuItem(value: 4, child: Text('4')),
                  DropdownMenuItem(value: 0, child: Text('tab')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _indent = v == 0 ? 4 : v);
                },
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _minify,
                icon: const Icon(Icons.compress, size: 16),
                label: const Text('Minify'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _format,
                icon: const Icon(Icons.format_align_left, size: 16),
                label: const Text('Format'),
              ),
            ],
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                _panel(
                  label: 'Input',
                  controller: _input,
                  readOnly: false,
                  actions: [
                    IconButton(
                      iconSize: 16,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 24, minHeight: 24),
                      tooltip: 'Paste',
                      icon: const Icon(Icons.content_paste),
                      onPressed: () async {
                        final data =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        if (data?.text != null) {
                          _input.text = data!.text!;
                        }
                      },
                    ),
                    IconButton(
                      iconSize: 16,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 24, minHeight: 24),
                      tooltip: 'Clear',
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _input.clear();
                        _output.clear();
                        setState(() {});
                      },
                    ),
                  ],
                ),
                _panel(
                  label: 'Output',
                  controller: _output,
                  readOnly: true,
                  actions: [
                    IconButton(
                      iconSize: 16,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 24, minHeight: 24),
                      tooltip: 'Copy',
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: _output.text));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

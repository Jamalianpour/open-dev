import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/dart_class_utils.dart';

class DartClassView extends StatefulWidget {
  const DartClassView({super.key});

  @override
  State<DartClassView> createState() => _DartClassViewState();
}

class _DartClassViewState extends State<DartClassView> {
  final TextEditingController _input = TextEditingController(text: '''{
  "id": 42,
  "name": "Ada Lovelace",
  "active": true,
  "tags": ["math", "computing"],
  "address": {
    "street": "12 Computing Way",
    "zip": "00000"
  },
  "friends": [
    { "id": 1, "name": "Charles" }
  ]
}''');
  final TextEditingController _output = TextEditingController();
  final TextEditingController _className =
      TextEditingController(text: 'Root');
  bool _nullable = true;
  bool _immutable = true;
  String? _error;

  @override
  void dispose() {
    _input.dispose();
    _output.dispose();
    _className.dispose();
    super.dispose();
  }

  void _generate() {
    try {
      _output.text = DartClassUtils.generate(
        _input.text,
        rootName:
            _className.text.trim().isEmpty ? 'Root' : _className.text.trim(),
        nullable: _nullable,
        immutable: _immutable,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    setState(() {});
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
              Text('JSON → Dart class',
                  style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              SizedBox(
                width: 160,
                child: TextField(
                  controller: _className,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Class name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(width: 12),
              Row(children: [
                const Text('Nullable'),
                Switch(
                  value: _nullable,
                  onChanged: (v) => setState(() => _nullable = v),
                ),
              ]),
              const SizedBox(width: 4),
              Row(children: [
                const Text('Immutable'),
                Switch(
                  value: _immutable,
                  onChanged: (v) => setState(() => _immutable = v),
                ),
              ]),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _generate,
                icon: const Icon(Icons.bolt, size: 16),
                label: const Text('Generate'),
              ),
            ],
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(_error!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontFamily: 'monospace')),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                _panel(
                  label: 'JSON',
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
                        setState(() => _error = null);
                      },
                    ),
                  ],
                ),
                _panel(
                  label: 'Dart',
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

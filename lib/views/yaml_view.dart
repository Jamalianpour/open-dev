import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/json_utils.dart';

class YamlView extends StatefulWidget {
  const YamlView({super.key});

  @override
  State<YamlView> createState() => _YamlViewState();
}

class _YamlViewState extends State<YamlView> {
  final TextEditingController _input = TextEditingController(text: '''
name: open_dev
version: 0.5.1
features:
  - json
  - yaml
  - diff
nested:
  count: 3
  active: true
''');
  final TextEditingController _output = TextEditingController();
  String? _error;

  void _convert() {
    try {
      _output.text = convertYamlToJson(_input.text);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _input.dispose();
    _output.dispose();
    super.dispose();
  }

  Widget _panel({
    required String label,
    required TextEditingController controller,
    required bool readOnly,
    required List<Widget> actions,
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
                style:
                    const TextStyle(fontFamily: 'monospace', fontSize: 13),
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
              Text('YAML → JSON',
                  style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              FilledButton.icon(
                onPressed: _convert,
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Convert'),
              ),
            ],
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              _error!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontFamily: 'monospace'),
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                _panel(
                  label: 'YAML',
                  controller: _input,
                  readOnly: false,
                  actions: [
                    IconButton(
                      iconSize: 16,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                          minWidth: 24, minHeight: 24),
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
                      constraints: const BoxConstraints(
                          minWidth: 24, minHeight: 24),
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
                  label: 'JSON',
                  controller: _output,
                  readOnly: true,
                  actions: [
                    IconButton(
                      iconSize: 16,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                          minWidth: 24, minHeight: 24),
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

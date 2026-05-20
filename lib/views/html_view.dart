import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/html_utils.dart';

enum _HtmlMode { encode, decode }

class HtmlView extends StatefulWidget {
  const HtmlView({super.key});

  @override
  State<HtmlView> createState() => _HtmlViewState();
}

class _HtmlViewState extends State<HtmlView> {
  final TextEditingController _input = TextEditingController();
  final TextEditingController _output = TextEditingController();
  _HtmlMode _mode = _HtmlMode.encode;
  bool _attributeMode = false;

  @override
  void dispose() {
    _input.dispose();
    _output.dispose();
    super.dispose();
  }

  void _convert() {
    final t = _input.text;
    try {
      switch (_mode) {
        case _HtmlMode.encode:
          _output.text = _attributeMode
              ? HtmlUtils.encodeForAttribute(t)
              : HtmlUtils.encode(t);
        case _HtmlMode.decode:
          _output.text = HtmlUtils.decode(t);
      }
      setState(() {});
    } catch (_) {
      // HtmlEscape / decode don't throw on malformed input.
    }
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
                style: const TextStyle(
                    fontFamily: 'monospace', fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), gapPadding: 0),
                  contentPadding: const EdgeInsets.all(12),
                ),
                onChanged: readOnly ? null : (_) => _convert(),
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
              Text('HTML Encode / Decode',
                  style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              SegmentedButton<_HtmlMode>(
                segments: const [
                  ButtonSegment(
                      value: _HtmlMode.encode, label: Text('Encode')),
                  ButtonSegment(
                      value: _HtmlMode.decode, label: Text('Decode')),
                ],
                selected: {_mode},
                onSelectionChanged: (s) {
                  setState(() => _mode = s.first);
                  _convert();
                },
                showSelectedIcon: false,
              ),
              if (_mode == _HtmlMode.encode) ...[
                const SizedBox(width: 12),
                Row(children: [
                  const Text('Attribute-safe'),
                  Switch(
                    value: _attributeMode,
                    onChanged: (v) {
                      setState(() => _attributeMode = v);
                      _convert();
                    },
                  ),
                ]),
              ],
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
                  label: _mode == _HtmlMode.encode ? 'Raw text' : 'HTML',
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
                          _convert();
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
                        setState(() {});
                      },
                    ),
                  ],
                ),
                _panel(
                  label: _mode == _HtmlMode.encode ? 'HTML' : 'Raw text',
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

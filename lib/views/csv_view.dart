import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/csv_utils.dart';

enum _CsvMode { csvToJson, jsonToCsv }

class CsvView extends StatefulWidget {
  const CsvView({super.key});

  @override
  State<CsvView> createState() => _CsvViewState();
}

class _CsvViewState extends State<CsvView> {
  final TextEditingController _input = TextEditingController(text: '''name,age,active
Ada,36,true
Linus,54,true
Margaret,87,false''');
  final TextEditingController _output = TextEditingController();
  _CsvMode _mode = _CsvMode.csvToJson;
  String _delimiter = ',';
  String? _error;
  List<List<String>> _table = const [];

  @override
  void dispose() {
    _input.dispose();
    _output.dispose();
    super.dispose();
  }

  void _convert() {
    try {
      switch (_mode) {
        case _CsvMode.csvToJson:
          _output.text =
              CsvUtils.csvToJson(_input.text, delimiter: _delimiter);
          _table = CsvUtils.parse(_input.text, delimiter: _delimiter);
        case _CsvMode.jsonToCsv:
          _output.text =
              CsvUtils.jsonToCsv(_input.text, delimiter: _delimiter);
          _table = CsvUtils.parse(_output.text, delimiter: _delimiter);
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      _table = const [];
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

  Widget _tablePreview(BuildContext context) {
    if (_table.isEmpty) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    final header = _table.first;
    final body = _table.skip(1).toList();
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
              WidgetStatePropertyAll(cs.surfaceVariant.withOpacity(0.5)),
          columns: [
            for (final h in header)
              DataColumn(
                  label: Text(h,
                      style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold))),
          ],
          rows: [
            for (final r in body)
              DataRow(cells: [
                for (int i = 0; i < header.length; i++)
                  DataCell(Text(
                    i < r.length ? r[i] : '',
                    style: const TextStyle(
                        fontFamily: 'monospace', fontSize: 12),
                  )),
              ]),
          ],
        ),
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
              Text('CSV ↔ JSON',
                  style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              SegmentedButton<_CsvMode>(
                segments: const [
                  ButtonSegment(
                      value: _CsvMode.csvToJson, label: Text('CSV → JSON')),
                  ButtonSegment(
                      value: _CsvMode.jsonToCsv, label: Text('JSON → CSV')),
                ],
                selected: {_mode},
                onSelectionChanged: (s) {
                  setState(() {
                    _mode = s.first;
                    final tmp = _input.text;
                    _input.text = _output.text;
                    _output.text = tmp;
                  });
                },
                showSelectedIcon: false,
              ),
              const SizedBox(width: 12),
              const Text('Delimiter:'),
              const SizedBox(width: 6),
              DropdownButton<String>(
                value: _delimiter,
                items: const [
                  DropdownMenuItem(value: ',', child: Text(',')),
                  DropdownMenuItem(value: ';', child: Text(';')),
                  DropdownMenuItem(value: '\t', child: Text('\\t')),
                  DropdownMenuItem(value: '|', child: Text('|')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _delimiter = v);
                },
              ),
              const SizedBox(width: 12),
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(_error!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontFamily: 'monospace')),
          ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              _panel(
                label: _mode == _CsvMode.csvToJson ? 'CSV' : 'JSON',
                controller: _input,
                readOnly: false,
              ),
              _panel(
                label: _mode == _CsvMode.csvToJson ? 'JSON' : 'CSV',
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
                      Clipboard.setData(ClipboardData(text: _output.text));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(child: _tablePreview(context)),
        ),
      ],
    );
  }
}

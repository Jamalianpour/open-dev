import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/diff_utils.dart';
import 'package:open_dev/utils/json_utils.dart';

class DiffView extends StatefulWidget {
  const DiffView({super.key});

  @override
  State<DiffView> createState() => _DiffViewState();
}

class _DiffViewState extends State<DiffView> {
  final TextEditingController _left = TextEditingController();
  final TextEditingController _right = TextEditingController();
  List<DiffLine> _diff = const [];
  bool _jsonMode = false;
  String? _error;

  @override
  void dispose() {
    _left.dispose();
    _right.dispose();
    super.dispose();
  }

  void _compute() {
    String l = _left.text;
    String r = _right.text;
    String? err;
    if (_jsonMode) {
      try {
        if (l.trim().isNotEmpty) l = prettyJson(l);
        if (r.trim().isNotEmpty) r = prettyJson(r);
      } catch (e) {
        err = e.toString();
      }
    }
    setState(() {
      _error = err;
      _diff = err == null ? DiffUtils.lineDiff(l, r) : const [];
    });
  }

  Widget _inputPanel({
    required String label,
    required TextEditingController controller,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Text(label),
                const Spacer(),
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
                      controller.text = data!.text!;
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
                  onPressed: () => setState(() => controller.clear()),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: controller,
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

  Widget _diffPanel(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(_error!,
            style: TextStyle(color: cs.error, fontFamily: 'monospace')),
      );
    }
    if (_diff.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Press Compare to see the diff.'),
      );
    }

    Color bg(DiffOp op) {
      switch (op) {
        case DiffOp.insert:
          return Colors.green.withOpacity(0.18);
        case DiffOp.delete:
          return Colors.red.withOpacity(0.18);
        case DiffOp.equal:
          return Colors.transparent;
      }
    }

    String marker(DiffOp op) {
      switch (op) {
        case DiffOp.insert:
          return '+';
        case DiffOp.delete:
          return '-';
        case DiffOp.equal:
          return ' ';
      }
    }

    final stats = DiffUtils.stats(_diff);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              _StatChip(
                  label: '+${stats.added}', color: Colors.green.shade400),
              const SizedBox(width: 8),
              _StatChip(
                  label: '-${stats.removed}', color: Colors.red.shade400),
              const SizedBox(width: 8),
              _StatChip(
                  label: '${stats.unchanged} unchanged',
                  color: cs.onSurface.withOpacity(0.5)),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: cs.outlineVariant),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: _diff.length,
              itemBuilder: (context, i) {
                final d = _diff[i];
                return Container(
                  color: bg(d.op),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 36,
                        child: Text(
                          d.leftLineNo?.toString() ?? '',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: cs.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 36,
                        child: Text(
                          d.rightLineNo?.toString() ?? '',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: cs.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 14,
                        child: Text(
                          marker(d.op),
                          style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: SelectableText(
                          d.text,
                          style: const TextStyle(
                              fontFamily: 'monospace', fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
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
              Text('Text / JSON Diff',
                  style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              Row(
                children: [
                  const Text('JSON-aware'),
                  Switch(
                    value: _jsonMode,
                    onChanged: (v) => setState(() => _jsonMode = v),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _compute,
                icon: const Icon(Icons.difference, size: 16),
                label: const Text('Compare'),
              ),
            ],
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              _inputPanel(label: 'Left', controller: _left),
              _inputPanel(label: 'Right', controller: _right),
            ],
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
        Expanded(flex: 3, child: _diffPanel(context)),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }
}

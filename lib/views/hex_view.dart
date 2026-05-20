import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HexView extends StatefulWidget {
  const HexView({super.key});

  @override
  State<HexView> createState() => _HexViewState();
}

class _HexViewState extends State<HexView> {
  Uint8List? _bytes;
  String? _fileName;
  int _bytesPerRow = 16;
  // Cap rendering so we don't try to build millions of rows in a ListView.
  static const int _maxBytes = 1024 * 1024; // 1 MiB

  Future<void> _pick() async {
    final result = await FilePicker.pickFiles(withData: true);
    if (result == null || result.files.isEmpty) return;
    final f = result.files.single;
    if (f.bytes == null) return;
    setState(() {
      _bytes = f.bytes;
      _fileName = f.name;
    });
  }

  String _hex(int b) => b.toRadixString(16).padLeft(2, '0').toUpperCase();
  String _printable(int b) => (b >= 0x20 && b <= 0x7E) ? String.fromCharCode(b) : '.';

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
  }

  void _copyAsHex() {
    if (_bytes == null) return;
    final buffer = StringBuffer();
    for (final b in _bytes!) {
      buffer.write(_hex(b));
    }
    Clipboard.setData(ClipboardData(text: buffer.toString()));
  }

  Widget _buildEmpty(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          border: Border.all(color: cs.outlineVariant, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.code_off,
                size: 56, color: cs.onSurface.withOpacity(0.4)),
            const SizedBox(height: 16),
            const Text('Choose a file to view its raw bytes.'),
          ],
        ),
      ),
    );
  }

  Widget _buildDump(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bytes = _bytes!;
    final visibleLen =
        bytes.length > _maxBytes ? _maxBytes : bytes.length;
    final rowCount = (visibleLen + _bytesPerRow - 1) ~/ _bytesPerRow;
    final truncated = bytes.length > _maxBytes;

    final addrWidth = (bytes.length.toRadixString(16).length).clamp(6, 12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.description, color: cs.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(_fileName ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis),
              ),
              Text('${_formatBytes(bytes.length)}'
                  '${truncated ? ' (showing first 1 MiB)' : ''}',
                  style: TextStyle(
                      color: cs.onSurface.withOpacity(0.7),
                      fontSize: 12,
                      fontFamily: 'monospace')),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: cs.outlineVariant),
              borderRadius: BorderRadius.circular(8),
              color: cs.surfaceVariant.withOpacity(0.3),
            ),
            child: ListView.builder(
              itemCount: rowCount,
              itemBuilder: (context, i) {
                final start = i * _bytesPerRow;
                final end = (start + _bytesPerRow).clamp(0, visibleLen);
                final row = bytes.sublist(start, end);
                final hex = row.map(_hex).join(' ').padRight(
                    _bytesPerRow * 3 - 1, ' ');
                final ascii = row.map(_printable).join();
                final addr = start
                    .toRadixString(16)
                    .padLeft(addrWidth, '0')
                    .toUpperCase();
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 1),
                  child: Row(
                    children: [
                      Text(addr,
                          style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: cs.primary)),
                      const SizedBox(width: 16),
                      SelectableText(hex,
                          style: const TextStyle(
                              fontFamily: 'monospace', fontSize: 12)),
                      const SizedBox(width: 16),
                      SelectableText(ascii,
                          style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: cs.onSurface.withOpacity(0.8))),
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
              Text('Hex Viewer',
                  style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              const Text('Width: '),
              const SizedBox(width: 6),
              DropdownButton<int>(
                value: _bytesPerRow,
                items: const [
                  DropdownMenuItem(value: 8, child: Text('8')),
                  DropdownMenuItem(value: 16, child: Text('16')),
                  DropdownMenuItem(value: 32, child: Text('32')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _bytesPerRow = v);
                },
              ),
              const SizedBox(width: 12),
              if (_bytes != null) ...[
                OutlinedButton.icon(
                  onPressed: _copyAsHex,
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy hex'),
                ),
                const SizedBox(width: 8),
              ],
              FilledButton.icon(
                onPressed: _pick,
                icon: const Icon(Icons.upload_file, size: 16),
                label: const Text('Choose file'),
              ),
            ],
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
        Expanded(
          child: _bytes == null ? _buildEmpty(context) : _buildDump(context),
        ),
      ],
    );
  }
}

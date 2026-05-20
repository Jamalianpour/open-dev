import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/widgets/data_widget.dart';

class FileHashView extends StatefulWidget {
  const FileHashView({super.key});

  @override
  State<FileHashView> createState() => _FileHashViewState();
}

class _FileHashViewState extends State<FileHashView> {
  String? _fileName;
  int? _fileSize;
  bool _computing = false;
  Map<String, String> _hashes = const {};
  final TextEditingController _verifyController = TextEditingController();

  @override
  void dispose() {
    _verifyController.dispose();
    super.dispose();
  }

  Future<void> _pickAndHash() async {
    final result = await FilePicker.pickFiles(withData: true);
    if (result == null || result.files.isEmpty) return;
    final f = result.files.single;
    final bytes = f.bytes;
    if (bytes == null) return;
    setState(() {
      _fileName = f.name;
      _fileSize = f.size;
      _computing = true;
      _hashes = const {};
    });
    final computed = await _computeHashes(bytes);
    if (!mounted) return;
    setState(() {
      _hashes = computed;
      _computing = false;
    });
  }

  Future<Map<String, String>> _computeHashes(Uint8List bytes) async {
    return {
      'MD5': md5.convert(bytes).toString(),
      'SHA-1': sha1.convert(bytes).toString(),
      'SHA-256': sha256.convert(bytes).toString(),
      'SHA-384': sha384.convert(bytes).toString(),
      'SHA-512': sha512.convert(bytes).toString(),
    };
  }

  bool? get _verifyResult {
    final v = _verifyController.text.trim().toLowerCase();
    if (v.isEmpty || _hashes.isEmpty) return null;
    return _hashes.values.any((h) => h.toLowerCase() == v);
  }

  String _formatBytes(int? bytes) {
    if (bytes == null) return '';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
    }
    return '${(bytes / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final verifyResult = _verifyResult;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Text('File Hash',
                  style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              FilledButton.icon(
                onPressed: _computing ? null : _pickAndHash,
                icon: const Icon(Icons.upload_file, size: 16),
                label: const Text('Choose file'),
              ),
            ],
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_fileName == null && !_computing)
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: cs.outlineVariant,
                              style: BorderStyle.solid,
                              width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.fingerprint,
                                size: 56, color: cs.onSurface.withOpacity(0.4)),
                            const SizedBox(height: 16),
                            const Text(
                                'Choose a file to compute its checksums.'),
                            const SizedBox(height: 4),
                            Text(
                              'MD5 · SHA-1 · SHA-256 · SHA-384 · SHA-512',
                              style: TextStyle(
                                  color: cs.onSurface.withOpacity(0.6),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_computing)
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Hashing…'),
                        ],
                      ),
                    ),
                  ),
                if (_fileName != null && !_computing) ...[
                  Row(children: [
                    Icon(Icons.description, color: cs.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _fileName!,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(_formatBytes(_fileSize),
                        style: TextStyle(
                            color: cs.onSurface.withOpacity(0.6),
                            fontFamily: 'monospace')),
                  ]),
                  const SizedBox(height: 16),
                  for (final entry in _hashes.entries) ...[
                    DataWidget(
                      title: entry.key,
                      value: entry.value,
                      width: 700,
                      maxWidth: 900,
                      minWidth: 500,
                      textStyle: const TextStyle(
                          fontFamily: 'monospace', fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 8),
                  Text('Verify against expected hash',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _verifyController,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText:
                                'Paste an expected hash (any algorithm)…',
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                gapPadding: 0),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          style: const TextStyle(
                              fontFamily: 'monospace', fontSize: 12),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (verifyResult == true)
                        Row(children: [
                          Icon(Icons.check_circle,
                              color: Colors.green.shade400),
                          const SizedBox(width: 4),
                          const Text('Match'),
                        ])
                      else if (verifyResult == false)
                        Row(children: [
                          Icon(Icons.cancel, color: cs.error),
                          const SizedBox(width: 4),
                          const Text('No match'),
                        ]),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

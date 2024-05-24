import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataWidget extends StatelessWidget {
  const DataWidget({
    super.key,
    this.title,
    required this.value,
    this.width = 275,
    this.maxWidth, this.minWidth,
  });

  final String? title;
  final String value;
  final double? width;
  final double? maxWidth;
  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Text(title!),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: width,
              constraints: BoxConstraints(minWidth: minWidth ?? 275, maxWidth: maxWidth ?? 275),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(6)),
              child: SelectableText(
                value,
                // maxLines: 2,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            IconButton.outlined(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
              },
              icon: const Icon(CupertinoIcons.doc_on_clipboard_fill),
              iconSize: 16,
              tooltip: 'Copy',
              constraints: const BoxConstraints.tightFor(),
            )
          ],
        )
      ],
    );
  }
}

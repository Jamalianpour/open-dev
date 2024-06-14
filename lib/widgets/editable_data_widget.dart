import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditableDataWidget extends StatelessWidget {
  const EditableDataWidget({
    super.key,
    this.title,
    this.width = 275,
    this.maxWidth,
    this.minWidth,
    this.borderColor = Colors.transparent,
    required this.onChanged,
  });

  final String? title;
  final Color borderColor;
  final double? width;
  final double? maxWidth;
  final double? minWidth;
  final TextEditingController onChanged;

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
                // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(6)),
                child: TextField(
                  controller: onChanged,
                  decoration: InputDecoration(
                    hintText: 'Value',
                    border: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )),
            const SizedBox(
              width: 4,
            ),
            IconButton.outlined(
              onPressed: () async {
                final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                onChanged.text = clipboardData?.text ?? '';
              },
              icon: const Icon(Icons.paste),
              iconSize: 16,
              tooltip: 'Paste',
              constraints: const BoxConstraints.tightFor(),
            )
          ],
        )
      ],
    );
  }
}

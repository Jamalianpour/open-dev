import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/qr_utils.dart';
import 'package:open_dev/widgets/secondary_button.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrView extends StatefulWidget {
  const QrView({super.key});

  @override
  State<QrView> createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
  final TextEditingController _input = TextEditingController(text: 'https://open_dev.app/');
  final QrUtils _qrUtils = QrUtils();
  bool roundedCode = false;

  File? selectedFile;

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('Qr code Generator', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const Divider(
          indent: 8,
          endIndent: 8,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('input:'),
                          const Spacer(),
                          SecondaryButton(
                              text: 'Embedded image',
                              onTap: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

                                if (result != null) {
                                  selectedFile = File(result.files.single.path!);
                                  setState(() {});
                                }
                              }),
                          const SizedBox(
                            width: 4,
                          ),
                          SecondaryButton(
                            text: 'Clipboard',
                            onTap: () async {
                              ClipboardData? data = await Clipboard.getData('text/plain');
                              if (data != null) {
                                _input.text = data.text ?? '';
                              }
                            },
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          SecondaryButton(
                            text: 'Sample',
                            onTap: () {
                              setState(() {
                                _input.text = 'This is a sample text to hash generator';
                              });
                            },
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          SecondaryButton(
                            text: 'Clear',
                            onTap: () {
                              setState(() {
                                _input.clear();
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _input,
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), gapPadding: 0),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                          maxLines: 999,
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ToggleButtons(
                      isSelected: [roundedCode, !roundedCode],
                      onPressed: (index) {
                        roundedCode = !roundedCode;
                        setState(() {});
                      },
                      borderRadius: BorderRadius.circular(6),
                      constraints: const BoxConstraints(minHeight: 25, minWidth: 70),
                      children: const [
                        Text('Smooth'),
                        Text('Rounded'),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 350,
                      width: 350,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: PrettyQrView.data(
                          data: _input.text,
                          decoration: PrettyQrDecoration(
                            image: selectedFile == null
                                ? null
                                : PrettyQrDecorationImage(
                                    image: FileImage(selectedFile!),
                                  ),
                            background: Colors.white,
                            shape: roundedCode ? const PrettyQrRoundedSymbol() : const PrettyQrSmoothSymbol(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SecondaryButton(
                      text: 'Save code',
                      onTap: () async {
                        _qrUtils.saveImage(_input.text, embeddedImage: selectedFile, roundedCode: roundedCode);
                      },
                      icon: Icon(
                        Icons.save,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

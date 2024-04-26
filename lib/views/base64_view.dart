import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_dev/utils/base64_utils.dart';

import '../widgets/error_notification_widget.dart';

class Base64View extends StatefulWidget {
  const Base64View({super.key});

  @override
  State<Base64View> createState() => _Base64ViewState();
}

class _Base64ViewState extends State<Base64View> {
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  String errorMessage = '';
  bool isString = true;
  bool isEncode = true;
  File? selectedFile;

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('Base64 Encode/Decode', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
          ToggleButtons(
            isSelected: [isString, !isString],
            onPressed: (index) {
              isString = !isString;
              selectedFile = null;
              sourceController.clear();
              targetController.clear();
              setState(() {});
            },
            borderRadius: BorderRadius.circular(6),
            constraints: const BoxConstraints(minHeight: 25, minWidth: 60),
            children: const [
              Text('String'),
              Text('Image'),
            ],
          ),
        ],
      ),
    );
  }

  void _selectAndEncodeImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        targetController.text = 'Please wait...';
      });
      File file = File(result.files.single.path!);
      selectedFile = file;
      targetController.text = await Base64Utils.convertImageToBase64(file);
    }
    setState(() {});
  }

  Container _buildFunctionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Row(
        children: [
          if (isString)
            ElevatedButton(
              onPressed: () {
                try {
                  if (isEncode) {
                    targetController.text = Base64Utils.encode(sourceController.text);
                  } else {
                    targetController.text = Base64Utils.decode(sourceController.text);
                  }
                  errorMessage = '';
                } catch (e) {
                  errorMessage = e.toString();
                }
                setState(() {});
              },
              child: Text(isEncode ? 'Encode' : 'Decode'),
            )
          else
            ElevatedButton(
              onPressed: () async {
                if (isEncode) {
                  _selectAndEncodeImage();
                } else {
                  selectedFile = File('open_dev-tempImage');
                  await selectedFile!.writeAsBytes(await Base64Utils.convertBase64ToImage(sourceController.text));
                  setState(() {});
                }
              },
              child: Text(isEncode ? 'Load Image' : 'Decode'),
            ),
          const SizedBox(width: 8),
          const Spacer(),
          ToggleButtons(
            isSelected: [isEncode, !isEncode],
            onPressed: (index) {
              isEncode = !isEncode;
              setState(() {});
            },
            borderRadius: BorderRadius.circular(6),
            constraints: const BoxConstraints(minHeight: 25, minWidth: 70),
            children: const [
              Text('Encode'),
              Text('Decode'),
            ],
          ),
        ],
      ),
    );
  }

  IconButton _buildSwapButton() {
    return IconButton(
      onPressed: () {
        if (isString) {
          String temp = sourceController.text;
          sourceController.text = targetController.text;
          targetController.text = temp;
        } else {
          setState(() {
            String temp = sourceController.text;
            sourceController.text = targetController.text;
            targetController.text = temp;
            isEncode = !isEncode;
          });
        }
        setState(() {});
      },
      icon: const Icon(CupertinoIcons.arrow_up_arrow_down),
      iconSize: 20,
      constraints: const BoxConstraints.tightFor(),
    );
  }

  Padding _buildTargetBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: !isString && !isEncode
          ? Center(
              child: selectedFile != null ? Image.file(selectedFile!) : const Text('Decode Image'),
            )
          : TextField(
              controller: targetController,
              readOnly: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), filled: true, isDense: true, contentPadding: EdgeInsets.all(8)),
              maxLines: 100,
            ),
    );
  }

  Stack _buildSourceBox() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: !isString && isEncode
              ? Center(
                  child: selectedFile != null ? Image.file(selectedFile!) : const Text('Select Image'),
                )
              : TextField(
                  controller: sourceController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), filled: true, isDense: true, contentPadding: EdgeInsets.all(8)),
                  maxLines: 100,
                ),
        ),
        AnimatedAlign(
          duration: const Duration(milliseconds: 900),
          curve: Curves.elasticInOut,
          alignment: Alignment(0, errorMessage.isEmpty ? 6 : 1),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ErrorNotificationWidget(
              errorMessage: errorMessage,
              height: 70,
            ),
          ),
        )
      ],
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
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildFunctionBar(),
                    Expanded(
                      child: _buildSourceBox(),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                      child: Row(
                        children: [
                          _buildSwapButton(),
                          if (selectedFile != null) ...[
                            const Spacer(),
                            Text('size: ${(selectedFile!.lengthSync() / 1024).round()} KB'),
                          ]
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildTargetBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

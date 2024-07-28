import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_dev/utils/image_utils.dart';
import 'package:open_dev/widgets/error_notification_widget.dart';

class ImageView extends StatefulWidget {
  const ImageView({super.key});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  final ImageUtils _imageUtils = ImageUtils();
  File? selectedFile;
  Uint8List? convertedImage;

  final List<bool> targetExtensions = [true, false, false, false, false];

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('Image Formatter', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
        ],
      ),
    );
  }

  /// Builds the UI for the ImageView widget.
  ///
  /// Returns a Column widget that contains the UI elements for the ImageView.
  /// The UI includes a header, a source image, information about the selected image,
  /// toggle buttons for selecting the target image format, a Convert button,
  /// a result image, information about the converted image, and a Save button.
  ///
  /// The UI elements are arranged in a Column widget with a crossAxisAlignment of
  /// CrossAxisAlignment.start. The Column contains a Row widget that contains
  /// two Expanded widgets, each containing a Column widget. The first Expanded
  /// widget contains the source image and related information, while the second
  /// Expanded widget contains the result image and related information.
  ///
  /// The source image is displayed using an Image.file widget and can be selected
  /// by tapping on it. The selected image is stored in the selectedFile variable.
  /// The information about the selected image includes the name, size, and type.
  ///
  /// The toggle buttons allow the user to select the target image format.
  /// The Convert button is enabled only when a source image is selected and a
  /// target format is selected. When the button is pressed, the selected image
  /// is converted to the selected format and the converted image is stored in
  /// the convertedImage variable.
  ///
  /// The result image is displayed using an Image.memory widget and shows the
  /// converted image. The information about the converted image includes the size.
  ///
  /// The Save button is enabled only when a converted image is available.
  /// When the button is pressed, the converted image is saved to the device
  /// with the selected file name and format.
  ///
  /// The UI is built using various widgets such as Text, Padding, AspectRatio,
  /// Container, ElevatedButton, and Icon.
  ///
  /// The build method does not take any parameters.
  ///
  /// The build method does not return anything.
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
          child: Row(
            children: [
              sourceImageWidget(context),
              const VerticalDivider(),
              resultImageWidget(context),
            ],
          ),
        )
      ],
    );
  }

  /// Returns an `Expanded` widget that displays the result image.
  ///
  /// The widget contains a `Column` with multiple children, including a `Text` widget
  /// displaying the text 'result', a `Padding` widget containing an `AspectRatio` widget
  /// with a `Container` that displays the converted image using an `Image.memory` widget.
  /// If no image is converted, a default icon and text are displayed. Below the image,
  /// there is a `Padding` widget that displays the size of the converted image. Finally,
  /// there is an `ElevatedButton` widget that allows the user to save the converted image
  /// with a specific extension when pressed.
  ///
  /// Parameters:
  /// - `context`: The build context of the widget.
  ///
  /// Returns:
  /// An `Expanded` widget.
  Expanded resultImageWidget(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text(
            'result',
            style: TextStyle(fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).focusColor,
                  border: Border.all(color: Theme.of(context).focusColor),
                ),
                child: convertedImage != null
                    ? Image.memory(convertedImage!)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              CupertinoIcons.photo,
                              size: 70,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Final Image',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            child: Text(
                              'JPG, PNG, ICO, GIF, BMP',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('size: ${_imageUtils.getImageSize(convertedImage?.length ?? 0)}'),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: convertedImage != null
                ? () async {
                    String extension = targetExtensions[0]
                        ? 'JPG'
                        : targetExtensions[1]
                            ? 'PNG'
                            : targetExtensions[2]
                                ? 'ICO'
                                : targetExtensions[3]
                                    ? 'GIF'
                                    : targetExtensions[4]
                                        ? 'BMP'
                                        : 'PNG';
                    if (convertedImage != null) {
                      var result = await FilePicker.platform.saveFile(
                        allowedExtensions: [extension],
                        bytes: convertedImage,
                        fileName: '${selectedFile!.path.split('/').last.split('.').first}.$extension',
                        type: FileType.custom,
                        dialogTitle: 'save converted image',
                      );

                      if (result != null) {
                        File file = await File(result).create();
                        file.writeAsBytesSync(convertedImage!);
                      }
                    }
                  }
                : null,
            label: const Text('Save'),
            icon: const Icon(
              Icons.save,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// Returns an `Expanded` widget that displays the source image.
  ///
  /// The widget contains a `Column` with multiple children, including a `Text` widget
  /// displaying the text 'source', a `Padding` widget containing an `AspectRatio` widget
  /// with a `MouseRegion` and a `GestureDetector` that allows the user to select an image
  /// file. The selected image is displayed using an `Image.file` widget. If no image is
  /// selected, a default icon and text are displayed. Below the image, there is a
  /// `SizedBox` widget that displays information about the selected image, including the
  /// name, size, and type. Below that, there is a `ToggleButtons` widget that allows the
  /// user to select the target image format. Finally, there is an `ElevatedButton` widget
  /// that converts the selected image to the target format when pressed.
  ///
  /// Parameters:
  /// - `context`: The build context of the widget.
  ///
  /// Returns:
  /// An `Expanded` widget.
  Expanded sourceImageWidget(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text(
            'source',
            style: TextStyle(fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: AspectRatio(
              aspectRatio: 1,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: kIsWeb
                      ? null
                      : () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

                          if (result != null) {
                            File file = File(result.files.single.path!);
                            selectedFile = file;
                          }
                          setState(() {});
                        },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).focusColor,
                      border: Border.all(color: Theme.of(context).focusColor),
                    ),
                    child: selectedFile != null
                        ? Image.file(selectedFile!)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  CupertinoIcons.photo,
                                  size: 70,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'Select Image',
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 20),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: Text(
                                  'JPG, PNG, ICO, GIF, BMP, TIFF, TGA, PVRTC, WEBP, PNM, EXR, PSD',
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (kIsWeb)
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(16, 8, 8, 0),
                                  child: ErrorNotificationWidget(
                                    errorMessage:
                                        'Image Formatter dose not work on web!!! Please try our desktop version.',
                                    height: 70,
                                  ),
                                )
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
          if (selectedFile != null)
            SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'name: ${selectedFile!.path.split('/').last}',
                    ),
                    Text('size: ${_imageUtils.getImageSize(selectedFile!.lengthSync())}'),
                    Text('type: ${selectedFile!.path.split('.').last}'),
                  ],
                ),
              ),
            ),
          ToggleButtons(
            isSelected: targetExtensions,
            onPressed: (index) {
              for (var i = 0; i < targetExtensions.length; i++) {
                targetExtensions[i] = false;
              }
              targetExtensions[index] = true;
              setState(() {});
            },
            borderRadius: BorderRadius.circular(6),
            constraints: const BoxConstraints(minHeight: 25, minWidth: 60),
            children: const [
              Text('JPG'),
              Text('PNG'),
              Text('ICO'),
              Text('GIF'),
              Text('BMP'),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          ElevatedButton(
            onPressed: selectedFile != null
                ? () async {
                    if (selectedFile == null) {
                      return;
                    } else {
                      String extension = targetExtensions[0]
                          ? 'JPG'
                          : targetExtensions[1]
                              ? 'PNG'
                              : targetExtensions[2]
                                  ? 'ICO'
                                  : targetExtensions[3]
                                      ? 'GIF'
                                      : targetExtensions[4]
                                          ? 'BMP'
                                          : 'PNG';

                      Uint8List? newImageBytes = await _imageUtils.convertImage(await selectedFile!.readAsBytes(),
                          path: selectedFile!.path, targetExtension: extension);

                      setState(() {
                        convertedImage = newImageBytes;
                      });
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Convert'),
          ),
        ],
      ),
    );
  }
}

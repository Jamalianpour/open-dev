import 'dart:typed_data';

import 'package:image/image.dart' as img;

class ImageUtils {
  
  /// Asynchronously converts an image represented as Uint8List data to a different image format based on the targetExtension parameter.
  /// Parameters:
  /// - data: The Uint8List representing the image data to convert.
  /// - path: The path to the image file, if applicable. Defaults to an empty string.
  /// - targetExtension: The target image format to convert to. Defaults to 'PNG'.
  /// Returns:
  /// A Future<Uint8List> representing the converted image data, or null if conversion fails.
  Future<Uint8List?> convertImage(Uint8List data, {String path = '', String targetExtension = 'PNG'}) async {
    var imageData = img.decodeNamedImage(path, data) ?? img.decodeImage(data);

    if (imageData == null) {
      return null;
    }

    targetExtension = targetExtension.toUpperCase();
    if (targetExtension == 'PNG') {
      return img.encodePng(imageData);
    } else if (targetExtension == 'JPG') {
      return img.encodeJpg(imageData);
    } else if (targetExtension == 'GIF') {
      return img.encodeGif(imageData);
    } else if (targetExtension == 'ICO') {
      img.Command cmd;
      if (path.isEmpty) {
        cmd = img.Command()
          ..decodeImage(data)
          ..copyResize(width: 256, height: 256)
          ..encodeIco();
      } else {
        cmd = img.Command()
          ..decodeNamedImage(path, data)
          ..copyResize(width: 256, height: 256)
          ..encodeIco();
      }

      var result = await cmd.executeThread();

      var icoImage = await result.getImage();

      return icoImage?.getBytes();
    } else if (targetExtension == 'BMP') {
      return img.encodeBmp(imageData);
    } else {
      return null;
    }
  }

  /// Returns a formatted string representing the size of the given image in megabytes,
  /// kilobytes, or bytes depending on the size of the image.
  ///
  /// Parameters:
  /// - `size`: An integer representing the size of the image in bytes.
  ///
  /// Returns:
  /// - A string representing the size of the image in megabytes, kilobytes, or bytes.
  String getImageSize(int size) {
    if (size > 1000000) {
      return '${((size / 1024) / 1024).toStringAsFixed(1)} MB';
    } else if (size > 100000) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(size / 1024).toStringAsFixed(0)} KB';
    }
  }
}

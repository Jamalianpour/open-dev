import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrUtils {
  
  /// Saves an image with the given [data] as a QR code.
  ///
  /// The [data] parameter represents the data to be encoded in the QR code.
  ///
  /// The optional [embeddedImage] parameter is an image that can be embedded in the QR code.
  ///
  /// The optional [roundedCode] parameter determines whether the QR code should have rounded corners.
  /// If set to `true`, the QR code will have rounded corners. If set to `false` or not provided, the QR code will have smooth corners.
  ///
  /// This function saves the QR code image as a PNG file with the name 'qr_code.png'.
  ///
  /// Returns `void`.
  void saveImage(String data, {File? embeddedImage, bool roundedCode = false}) async {
    final QrCode qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    final qrImage = QrImage(qrCode);
    final ByteData? qrImageBytes = await qrImage.toImageAsBytes(
      size: 512,
      format: ImageByteFormat.png,
      decoration: PrettyQrDecoration(
        image: embeddedImage == null
            ? null
            : PrettyQrDecorationImage(
                image: FileImage(embeddedImage),
              ),
        background: Colors.white,
        shape: roundedCode ? const PrettyQrRoundedSymbol() : const PrettyQrSmoothSymbol(),
      ),
    );

    var result = await FilePicker.platform.saveFile(
      allowedExtensions: ['png'],
      bytes: qrImageBytes!.buffer.asUint8List(),
      fileName: 'qr_code.png',
      type: FileType.custom,
    );
    if (result != null) {
      File file = await File(result).create();
      file.writeAsBytesSync(qrImageBytes.buffer.asUint8List());
    }
  }
}

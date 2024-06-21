import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrUtils {
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

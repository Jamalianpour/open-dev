import 'dart:convert';
import 'dart:io';

class Base64Utils {
  static String encode(String data) {
    return base64.encode(utf8.encode(data));
  }

  static String decode(String data) {
    return utf8.decode(base64.decode(data));
  }

  static Future<String> convertImageToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  static Future<List<int>> convertBase64ToImage(String base64String) async {
    return base64Decode(base64String);
  }
}

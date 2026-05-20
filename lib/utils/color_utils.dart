import 'package:flutter/painting.dart';

class ColorUtils {
  static String rgbToHex(int r, int g, int b) {
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }

  static Color hexToColor(String hex) {
    String hexValue = hex.replaceAll('#', '');
    int r = int.parse(hexValue.substring(0, 2), radix: 16);
    int g = int.parse(hexValue.substring(2, 4), radix: 16);
    int b = int.parse(hexValue.substring(4, 6), radix: 16);
    return Color.fromARGB(255, r, g, b);
  }

  static int hexToRgb(String hex) {
    String hexValue = hex.replaceAll('#', '');
    int r = int.parse(hexValue.substring(0, 2), radix: 16);
    int g = int.parse(hexValue.substring(2, 4), radix: 16);
    int b = int.parse(hexValue.substring(4, 6), radix: 16);
    return Color.fromARGB(255, r, g, b).value;
  }

  static String colorToHsl(Color color) {
    HSLColor hsl = HSLColor.fromColor(color);
    return 'hsl(${hsl.hue.ceil()}, ${(hsl.saturation * 100).ceil()}%, ${(hsl.lightness * 100).ceil()}%)';
  }

  static String colorToHsla(Color color) {
    HSLColor hsla = HSLColor.fromColor(color);
    return 'hsla(${hsla.hue.ceil()}, ${(hsla.saturation * 100).ceil()}%, ${(hsla.lightness * 100).ceil()}%, ${(hsla.alpha * 100).ceil()}%)';
  }

  static String colorToRgb(Color color) {
    return 'rgb(${color.red}, ${color.green}, ${color.blue})';
  }

  static String colorToRgba(Color color) {
    return 'rgba(${color.red}, ${color.green}, ${color.blue}, ${(color.alpha / 255).toStringAsFixed(2)})';
  }

  static String colorToCmyk(Color color) {
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;
    final maxC = [r, g, b].reduce((a, b) => a > b ? a : b);
    final k = 1.0 - maxC;
    double c = 0, m = 0, y = 0;
    if (k < 1.0) {
      c = (1.0 - r - k) / (1.0 - k);
      m = (1.0 - g - k) / (1.0 - k);
      y = (1.0 - b - k) / (1.0 - k);
    }
    return 'cmyk(${(c * 100).toStringAsFixed(0)}%, '
        '${(m * 100).toStringAsFixed(0)}%, '
        '${(y * 100).toStringAsFixed(0)}%, '
        '${(k * 100).toStringAsFixed(0)}%)';
  }

  // HSB (hue, saturation, brightness) is the same model as HSV.
  static String colorToHsb(Color color) {
    HSVColor hsv = HSVColor.fromColor(color);
    return 'hsb(${hsv.hue.ceil()}, ${(hsv.saturation * 100).ceil()}%, ${(hsv.value * 100).ceil()}%)';
  }
}

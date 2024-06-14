import 'package:flutter/painting.dart';
import 'package:flutter_color_models/flutter_color_models.dart';

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
    CmykColor cmykColor = RgbColor.fromColor(color).toCmykColor();
    var cyan = cmykColor.cyan;
    var magenta = cmykColor.magenta;
    var yellow = cmykColor.yellow;
    var black = cmykColor.black;

    return 'cmyk(${cyan.toStringAsFixed(0)}%, ${magenta.toStringAsFixed(0)}%, ${yellow.toStringAsFixed(0)}%, ${black.toStringAsFixed(0)}%)';
  }

  static String colorToHsb(Color color) {
    HsbColor hsb = RgbColor.fromColor(color).toHsbColor();
    return 'hsb(${hsb.hue.ceil()}, ${(hsb.saturation).ceil()}%, ${(hsb.brightness).ceil()}%)';
  }
}

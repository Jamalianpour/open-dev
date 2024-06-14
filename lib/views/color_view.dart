import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:open_dev/utils/color_utils.dart';

import '../widgets/data_widget.dart';
import '../widgets/editable_data_widget.dart';

class ColorView extends StatefulWidget {
  const ColorView({super.key});

  @override
  State<ColorView> createState() => _ColorViewState();
}

class _ColorViewState extends State<ColorView> {
  Color selectedColor = Colors.blue;
  final List<bool> paletteTypeToggles = [true, false, false, false];
  PaletteType paletteType = PaletteType.hsl;
  TextEditingController hexBox = TextEditingController();

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('Color Picker', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  void initState() {
    hexBox.addListener(() {
      selectedColor = ColorUtils.hexToColor(hexBox.text);
    });
    super.initState();
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
                      ToggleButtons(
                        isSelected: paletteTypeToggles,
                        onPressed: (index) {
                          switch (index) {
                            case 0:
                              paletteTypeToggles[0] = true;
                              paletteTypeToggles[1] = false;
                              paletteTypeToggles[2] = false;
                              paletteTypeToggles[3] = false;
                              paletteType = PaletteType.hsl;
                              break;
                            case 1:
                              paletteTypeToggles[0] = false;
                              paletteTypeToggles[1] = true;
                              paletteTypeToggles[2] = false;
                              paletteTypeToggles[3] = false;
                              paletteType = PaletteType.rgbWithRed;
                              break;
                            case 2:
                              paletteTypeToggles[0] = false;
                              paletteTypeToggles[1] = false;
                              paletteTypeToggles[2] = true;
                              paletteTypeToggles[3] = false;
                              paletteType = PaletteType.hueWheel;
                              break;
                            case 3:
                              paletteTypeToggles[0] = false;
                              paletteTypeToggles[1] = false;
                              paletteTypeToggles[2] = false;
                              paletteTypeToggles[3] = true;
                              paletteType = PaletteType.hsv;
                              break;
                            default:
                          }
                          setState(() {});
                        },
                        borderRadius: BorderRadius.circular(6),
                        borderWidth: 1.5,
                        constraints: const BoxConstraints(minHeight: 25, minWidth: 80),
                        children: const [
                          Text('hsl'),
                          Text('rgb'),
                          Text('hueWheel'),
                          Text('hsv'),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ColorPicker(
                        pickerColor: selectedColor,
                        onColorChanged: (Color value) {
                          selectedColor = value;
                          setState(() {});
                        },
                        colorPickerWidth: 500,
                        pickerAreaHeightPercent: 0.5,
                        // enableAlpha: true,
                        labelTypes: const [
                          ColorLabelType.hex,
                          ColorLabelType.hsl,
                          ColorLabelType.hsv,
                          ColorLabelType.rgb
                        ],
                        // displayThumbColor: true,
                        paletteType: paletteType,
                        hexInputController: hexBox,
                        // hexInputBar: true,
                        pickerAreaBorderRadius: BorderRadius.circular(8),
                        portraitOnly: true,
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditableDataWidget(
                        borderColor: selectedColor,
                        title: 'Hex',
                        width: MediaQuery.sizeOf(context).width * 0.29,
                        maxWidth: 460,
                        minWidth: 360,
                        onChanged: hexBox,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DataWidget(
                        value: selectedColor.toHexString(),
                        title: 'Hex with alpha',
                        width: MediaQuery.sizeOf(context).width * 0.29,
                        maxWidth: 460,
                        minWidth: 360,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DataWidget(
                        value: ColorUtils.colorToHsl(selectedColor),
                        title: 'HSL',
                        width: MediaQuery.sizeOf(context).width * 0.29,
                        maxWidth: 460,
                        minWidth: 360,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DataWidget(
                        value: ColorUtils.colorToHsla(selectedColor),
                        title: 'HSLA',
                        width: MediaQuery.sizeOf(context).width * 0.29,
                        maxWidth: 460,
                        minWidth: 360,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DataWidget(
                        value: ColorUtils.colorToHsb(selectedColor),
                        title: 'HSB (HSV)',
                        width: MediaQuery.sizeOf(context).width * 0.29,
                        maxWidth: 460,
                        minWidth: 360,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DataWidget(
                        value: ColorUtils.colorToRgb(selectedColor),
                        title: 'RGB',
                        width: MediaQuery.sizeOf(context).width * 0.29,
                        maxWidth: 460,
                        minWidth: 360,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DataWidget(
                        value: ColorUtils.colorToRgba(selectedColor),
                        title: 'RGBA',
                        width: MediaQuery.sizeOf(context).width * 0.29,
                        maxWidth: 460,
                        minWidth: 360,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DataWidget(
                        value: ColorUtils.colorToCmyk(selectedColor),
                        title: 'CMYK',
                        width: MediaQuery.sizeOf(context).width * 0.29,
                        maxWidth: 460,
                        minWidth: 360,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

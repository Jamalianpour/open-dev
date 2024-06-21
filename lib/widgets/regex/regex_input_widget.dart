import 'dart:math';

import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';

class RegexInputWidget extends StatelessWidget implements PreferredSizeWidget {
  final CodeFindController controller;
  final EdgeInsetsGeometry margin;
  final bool readOnly;
  final Color? iconColor;
  final Color? iconSelectedColor;
  final double iconSize;
  final double inputFontSize;
  final double resultFontSize;
  final Color? inputTextColor;
  final Color? resultFontColor;
  final EdgeInsetsGeometry padding;
  final InputDecoration decoration;

  const RegexInputWidget(
      {super.key,
      required this.controller,
      this.margin = const EdgeInsets.only(right: 10),
      required this.readOnly,
      this.iconSelectedColor,
      this.iconColor,
      this.iconSize = 16,
      this.inputFontSize = 13,
      this.resultFontSize = 12,
      this.inputTextColor,
      this.resultFontColor,
      this.padding = const EdgeInsets.only(left: 5, right: 5, top: 2.5, bottom: 2.5),
      this.decoration = const InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.only(
          left: 5,
          right: 5,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6)), gapPadding: 0),
        hintText: 'Type your Regex here ...',
      )});

  @override
  Size get preferredSize => const Size(double.infinity, 40);

  @override
  Widget build(BuildContext context) {
    if (controller.value == null) {
      return const SizedBox(width: 0, height: 0);
    }
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Container(
          child: _buildFindInputView(context),
        ),
      ),
    );
  }

  Widget _buildFindInputView(BuildContext context) {
    final CodeFindValue value = controller.value!;
    final String result;
    if (value.result == null) {
      result = 'none';
    } else {
      result = '${value.result!.index + 1}/${value.result!.matches.length}';
    }
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            context: context,
            controller: controller.findInputController,
            focusNode: controller.findInputFocusNode,
          ),
        ),
        Text(result, style: TextStyle(color: resultFontColor, fontSize: resultFontSize)),
        _buildIconButton(
            onPressed: value.result == null
                ? null
                : () {
                    controller.previousMatch();
                  },
            icon: Icons.arrow_upward,
            tooltip: 'Previous'),
        _buildIconButton(
            onPressed: value.result == null
                ? null
                : () {
                    controller.nextMatch();
                  },
            icon: Icons.arrow_downward,
            tooltip: 'Next'),
      ],
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return Padding(
      padding: padding,
      child: TextField(
        maxLines: 1,
        focusNode: focusNode,
        style: TextStyle(color: inputTextColor, fontSize: inputFontSize),
        decoration: decoration.copyWith(contentPadding: decoration.contentPadding ?? EdgeInsets.zero),
        controller: controller,
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, VoidCallback? onPressed, String? tooltip}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: iconSize,
      ),
      constraints: const BoxConstraints(maxWidth: 30, maxHeight: 30),
      tooltip: tooltip,
      splashRadius: max(30, 30) / 2,
    );
  }
}

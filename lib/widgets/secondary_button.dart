import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Icon? icon;
  final double? height;
  final Function onTap;
  const SecondaryButton({
    Key? key,
    required this.text,
    this.icon,
    required this.onTap,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: Row(
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(
                  width: 4,
                ),
              ],
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}

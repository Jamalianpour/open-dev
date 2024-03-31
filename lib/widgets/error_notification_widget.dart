import 'package:flutter/material.dart';
import 'package:open_dev/utils/extensions.dart';

class ErrorNotificationWidget extends StatelessWidget {
  const ErrorNotificationWidget({
    super.key,
    required this.errorMessage,
    this.width = double.maxFinite,
    this.height = 100,
  });

  final String errorMessage;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.errorContainer.lighten(),
        ),
      ),
      height: height,
      width: width,
      child: Text(
        errorMessage,
        style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
      ),
    );
  }
}

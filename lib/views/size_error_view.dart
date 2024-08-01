import 'package:flutter/material.dart';

class SizeErrorView extends StatelessWidget {
  const SizeErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo/icon.png',
                width: 125,
                height: 125,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Sorry but currently Open Dev is not supported on this device 📱. Please use a device with a larger screen 🖥️.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

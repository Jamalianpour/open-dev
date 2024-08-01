import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:open_dev/views/base_view.dart';
import 'package:open_dev/views/size_error_view.dart';
import 'package:window_manager/window_manager.dart';

import 'utils/color_schemes.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Window.initialize();
    await windowManager.ensureInitialized();

    // Window.disableZoomButton();
    Window.makeTitlebarTransparent();

    WindowOptions windowOptions = WindowOptions(
      size: const Size(1250, 700),
      center: true,
      // backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: Platform.isMacOS ? TitleBarStyle.hidden : TitleBarStyle.normal,
      title: 'Open Dev',
      minimumSize: const Size(1100, 600),
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    if (Platform.isWindows) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      WindowsDeviceInfo deviceInfoWindows = await deviceInfo.windowsInfo;
      if (deviceInfoWindows.productName.contains('Windows 11')) {
        await Window.setEffect(
          effect: WindowEffect.mica,
        );
      }
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Dev',
      theme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      debugShowCheckedModeBanner: false,
      home: kIsWeb
          ? MediaQuery.sizeOf(context).width < 800
              ? const SizeErrorView()
              : Container(color: Colors.grey[900], child: const BaseView())
          : const SafeArea(
              child: TitlebarSafeArea(
                child: BaseView(),
              ),
            ),
    );
  }
}

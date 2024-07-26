import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:open_dev/views/base_view.dart';
import 'package:window_manager/window_manager.dart';

import 'utils/color_schemes.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Window.initialize();
    await windowManager.ensureInitialized();

    // Window.disableZoomButton();
    Window.makeTitlebarTransparent();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1250, 700),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      minimumSize: Size(1100, 600),
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // await Window.setEffect(
  //   effect: WindowEffect.mica,
  // );

  // if (Platform.isWindows) {
  //   await Window.hideWindowControls();
  // }

  runApp(const MyApp());
  // if (Platform.isWindows) {
  //   doWhenWindowReady(() {
  //     appWindow
  //       ..minSize = Size(640, 360)
  //       ..size = Size(720, 540)
  //       ..alignment = Alignment.center
  //       ..show();
  //   });
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Dev',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      // darkTheme: ThemeData.dark(
      //   // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      debugShowCheckedModeBanner: false,
      home: kIsWeb ? const BaseView() : const SafeArea(child: TitlebarSafeArea(child: BaseView())),
    );
  }
}

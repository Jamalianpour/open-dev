import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:open_dev/views/base_view.dart';

import 'utils/color_schemes.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  Window.disableZoomButton();
  Window.makeTitlebarTransparent();

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
      title: 'Flutter Demo',
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
      home: const TitlebarSafeArea(child: BaseView()),
    );
  }
}

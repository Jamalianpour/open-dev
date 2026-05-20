import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:open_dev/utils/theme_notifier.dart';
import 'package:open_dev/utils/user_prefs.dart';
import 'package:open_dev/views/base_view.dart';
import 'package:open_dev/views/size_error_view.dart';
import 'package:window_manager/window_manager.dart';

import 'utils/color_schemes.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPrefs.instance.init();
  if (!kIsWeb) {
    await Window.initialize();
    await windowManager.ensureInitialized();

    // `makeTitlebarTransparent` is a macOS-only API; calling it on
    // Windows/Linux is undefined behaviour.
    if (Platform.isMacOS) {
      Window.makeTitlebarTransparent();
    }

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

    // Windows 11 → enable Mica behind translucent areas (just the title bar
    // gap, since the rest of the app paints its own surfaces). Older Windows
    // versions fall through silently.
    _isWindows11 = false;
    if (Platform.isWindows) {
      final deviceInfo = DeviceInfoPlugin();
      final info = await deviceInfo.windowsInfo;
      _isWindows11 = info.productName.contains('Windows 11');
    }

    // Sync native window appearance with the in-app theme toggle so the
    // titlebar / sidebar acrylic don't stay dark when the user picks light.
    await _applyWindowBrightness(themeMode.value);
    themeMode.addListener(() => _applyWindowBrightness(themeMode.value));
  }

  runApp(const MyApp());
}

bool _isWindows11 = false;

Future<void> _applyWindowBrightness(ThemeMode mode) async {
  if (kIsWeb) return;
  final isDark = mode == ThemeMode.dark;
  if (Platform.isMacOS) {
    Window.overrideMacOSBrightness(dark: isDark);
    return;
  }
  if (Platform.isWindows && _isWindows11) {
    // Mica picks up the system theme, but re-applying it on every toggle
    // also handles the case where Windows' own dark/light setting changes
    // while the app is running.
    await Window.setEffect(effect: WindowEffect.mica);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Open Dev',
          theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          darkTheme:
              ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
          themeMode: mode,
          debugShowCheckedModeBanner: false,
          home: kIsWeb
              ? MediaQuery.sizeOf(context).width < 800
                  ? const SizeErrorView()
                  : Container(
                      color: mode == ThemeMode.dark
                          ? Colors.grey[900]
                          : Colors.grey[100],
                      child: const BaseView())
              : const SafeArea(
                  child: TitlebarSafeArea(
                    child: BaseView(),
                  ),
                ),
        );
      },
    );
  }
}

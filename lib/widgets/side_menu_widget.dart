import 'dart:io';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_acrylic/widgets/transparent_macos_sidebar.dart';

class SideMenuWidget extends StatelessWidget {
  final SideMenuController sideMenu;
  const SideMenuWidget({super.key, required this.sideMenu});

  @override
  Widget build(BuildContext context) {
    List items = [
      SideMenuItem(
        title: 'Dashboard',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.home),
      ),
      SideMenuItem(
        title: 'Json',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.code),
      ),
      SideMenuItem(
        title: 'XML',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.chevron_left_slash_chevron_right),
      ),
      SideMenuItem(
        title: 'Cron',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.timer),
      ),
      SideMenuItem(
        title: 'Unix Time',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.time),
      ),
      SideMenuItem(
        title: 'Markdown',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.doc_text),
      ),
      SideMenuItem(
        title: 'Developer News',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.news),
      ),
      SideMenuItem(
        title: 'Base64',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.text_alignleft),
      ),
      SideMenuItem(
        title: 'JWT',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.code),
      ),
      SideMenuItem(
        title: 'Hash',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.fingerprint),
      ),
      SideMenuItem(
        title: 'Color Picker',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.color_lens),
      ),
      SideMenuItem(
        title: 'RegExp Tester',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.textformat),
      ),
      SideMenuItem(
        title: 'Lorem ipsum',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.textbox),
      ),
      SideMenuItem(
        title: 'Password',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.lock),
      ),
      SideMenuItem(
        title: 'QR Code',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.qrcode),
      ),
      SideMenuItem(
        title: 'Image Format',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.photo_fill),
      ),
      SideMenuItem(
        title: 'URL Parser',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.globe),
      ),
      SideMenuItem(
        title: 'UUID Generator/Decode',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.underline),
      ),
    ];

    Widget side() {
      return SideMenu(
        controller: sideMenu,
        items: items,
        title: kIsWeb
            ? Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                child: Row(
                  children: [
                    Semantics(
                      label: 'The Open Dev Logo',
                      header: true,
                      child: Image.asset(
                        'assets/logo/icon.png',
                        width: MediaQuery.sizeOf(context).width > 900 ? 65 : 50,
                        height: MediaQuery.sizeOf(context).width > 900 ? 65 : 50,
                      ),
                    ),
                    if (MediaQuery.sizeOf(context).width > 900) ...[
                      const SizedBox(width: 4),
                      Text(
                        'Open Dev',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ]
                  ],
                ),
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Open Dev',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
        style: SideMenuStyle(
          itemHeight: 35,
          openSideMenuWidth: 250,
          compactSideMenuWidth: 60,
          displayMode: MediaQuery.sizeOf(context).width < 900 ? SideMenuDisplayMode.compact : SideMenuDisplayMode.open,
          selectedTitleTextStyle: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary),
          unselectedTitleTextStyle: const TextStyle(fontSize: 14, color: Colors.white70),
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          hoverColor: Theme.of(context).hoverColor,
          iconSize: 20,
          selectedIconColor: Theme.of(context).colorScheme.primary,
          unselectedIconColor: Colors.white70,
        ),
      );
    }

    if (!kIsWeb) {
      return TransparentMacOSSidebar(
        effect: Platform.isMacOS ? WindowEffect.sidebar : WindowEffect.mica,
        child: side(),
      );
    } else {
      return side();
    }
  }
}

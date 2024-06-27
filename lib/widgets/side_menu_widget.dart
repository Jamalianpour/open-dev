import 'dart:io';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/widgets/transparent_macos_sidebar.dart';

class SideMenuWidget extends StatelessWidget {
  final SideMenuController sideMenu;
  const SideMenuWidget({super.key, required this.sideMenu});

  @override
  Widget build(BuildContext context) {
    List items = [
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
        title: 'Corn',
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
        title: 'Developer news',
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
        icon: const Icon(Icons.home),
      ),
      SideMenuItem(
        title: 'Hash',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.fingerprint),
      ),
      SideMenuItem(
        title: 'Color picker',
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
        title: 'Image format',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.photo_fill),
      ),
      SideMenuItem(
        title: 'URL parser',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(CupertinoIcons.globe),
      ),
    ];

    Widget _side() {
      return SideMenu(
        controller: sideMenu,
        items: items,
        title: const Center(
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
          // backgroundColor: Colors.transparent,
          // showHamburger: true,
          displayMode: SideMenuDisplayMode.open,
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

    return Platform.isMacOS ? TransparentMacOSSidebar(child: _side()) : _side();
  }
}

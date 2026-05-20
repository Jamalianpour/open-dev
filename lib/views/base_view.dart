import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:open_dev/utils/tool_registry.dart';
import 'package:open_dev/utils/user_prefs.dart';
import 'package:open_dev/widgets/command_palette.dart';
import 'package:open_dev/widgets/side_menu_widget.dart';

import 'dashboard_view.dart';

class BaseView extends StatefulWidget {
  const BaseView({super.key});

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
      // Page 0 is the Dashboard — only track real tools.
      if (index > 0 && index - 1 < kTools.length) {
        UserPrefs.instance.recordOpen(kTools[index - 1].title);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Neutral background only for the page area — leaves the sidebar pane
    // transparent so `TransparentMacOSSidebar` can still blur the desktop.
    final pageBackground = isDark ? Colors.grey[900] : Colors.grey[100];

    return CommandPaletteHost(
      sideMenu: sideMenu,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SideMenuWidget(sideMenu: sideMenu),
              const VerticalDivider(width: 0),
              Expanded(
                child: Container(
                  color: pageBackground,
                  child: PageView(
                    controller: pageController,
                    children: [
                      DashboardView(sideMenu: sideMenu),
                      for (final tool in kTools) tool.builder(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

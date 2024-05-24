import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:open_dev/views/cron_view.dart';
import 'package:open_dev/views/news_view.dart';
import 'package:open_dev/views/xml_view.dart';
import 'package:open_dev/widgets/side_menu_widget.dart';

import 'base64_view.dart';
import 'json_view.dart';
import 'jwt_view.dart';
import 'readme_view.dart';
import 'unix_time_view.dart';

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
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenuWidget(sideMenu: sideMenu),
          const VerticalDivider(
            width: 0,
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                const JsonView(),
                const XmlView(),
                const CronView(),
                const UnixTimeView(),
                const ReadmeView(),
                const NewsView(),
                const Base64View(),
                const JwtView(),
                Container(
                  child: const Center(
                    child: Text('Dashboard'),
                  ),
                ),
                Container(
                  child: const Center(
                    child: Text('Expansion Item 1'),
                  ),
                ),
                Container(
                  child: const Center(
                    child: Text('Expansion Item 2'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

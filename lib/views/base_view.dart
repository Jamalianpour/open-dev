import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:open_dev/widgets/side_menu_widget.dart';

import 'color_view.dart';
import 'cron_view.dart';
import 'dashboard_view.dart';
import 'hash_view.dart';
import 'image_view.dart';
import 'news_view.dart';
import 'xml_view.dart';
import 'base64_view.dart';
import 'json_view.dart';
import 'jwt_view.dart';
import 'lorem_view.dart';
import 'password_view.dart';
import 'qr_view.dart';
import 'readme_view.dart';
import 'regex_view.dart';
import 'unix_time_view.dart';
import 'url_view.dart';
import 'uuid_view.dart';

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
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
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
                  DashboardView(sideMenu: sideMenu),
                  const JsonView(),
                  const XmlView(),
                  const CronView(),
                  const UnixTimeView(),
                  const ReadmeView(),
                  const NewsView(),
                  const Base64View(),
                  const JwtView(),
                  const HashView(),
                  const ColorView(),
                  const RegexView(),
                  const LoremView(),
                  const PasswordView(),
                  const QrView(),
                  const ImageView(),
                  const UrlView(),
                  const UuidView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/dashboard/dashboard_card.dart';

class DashboardView extends StatelessWidget {
  final SideMenuController sideMenu;
  const DashboardView({super.key, required this.sideMenu});

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('Dashboard', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 4, top: 2),
            child: InkWell(
              onTap: () {
                launchUrl(Uri.parse('https://github.com/Jamalianpour/open-dev'));
              },
              customBorder: const CircleBorder(),
              child: Image.asset(
                'assets/images/github.png',
                width: 30,
                height: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        const Divider(
          indent: 8,
          endIndent: 8,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    border: Border.all(color: Theme.of(context).focusColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.info,
                        size: 22,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text('Welcome to OpenDev! The Free and Open Source assistant for easier Coding',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'Json | Master Your JSON! Format, minify, parse, validate, and convert it to Yaml with ease.',
                          child: DashboardCard(
                            title: 'Json',
                            description:
                                'Master Your JSON! Format, minify, parse, validate, and convert it to Yaml with ease.',
                            icon: Image.asset(
                              'assets/images/json.png',
                              width: 50,
                              height: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(1);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'XML | Play with XML. Format, parse, validate, and convert it to Json with ease.',
                          child: DashboardCard(
                            title: 'XML',
                            description: 'Play with XML. Format, parse, validate, and convert it to Json with ease.',
                            icon: Image.asset(
                              'assets/images/xml.png',
                              width: 50,
                              height: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(2);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'Cron | Interpret and validate cron expressions to ensure correct scheduling of automated tasks.',
                          child: DashboardCard(
                            title: 'Cron',
                            description:
                                'Interpret and validate cron expressions to ensure correct scheduling of automated tasks.',
                            icon: const Icon(
                              CupertinoIcons.timer,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(3);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'Unix Time | Convert Unix timestamps to human-readable dates and vice versa, simplifying the handling of time data.',
                          child: DashboardCard(
                            title: 'Unix Time',
                            description:
                                'Convert Unix timestamps to human-readable dates and vice versa, simplifying the handling of time data.',
                            icon: const Icon(
                              CupertinoIcons.time,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(4);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'Markdown | Create and preview README files in real-time to ensure your documentation looks perfect.',
                          child: DashboardCard(
                            title: 'Markdown',
                            description:
                                'Create and preview README files in real-time to ensure your documentation looks perfect.',
                            icon: const Icon(
                              CupertinoIcons.doc_text,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(5);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'Developer News | Stay updated with the latest developer news through RSS feeds from popular sources.',
                          child: DashboardCard(
                            title: 'Developer News',
                            description:
                                'Stay updated with the latest developer news through RSS feeds from popular sources.',
                            icon: const Icon(
                              CupertinoIcons.news,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(6);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'Base64 | Encode and decode Base64 strings and images for data processing and transmission.',
                          child: DashboardCard(
                            title: 'Base64',
                            description:
                                'Encode and decode Base64 strings and images for data processing and transmission.',
                            icon: const Icon(
                              CupertinoIcons.text_alignleft,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(7);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'JWT | Decode and debug JSON Web Tokens (JWT) to verify token contents and ensure security it locally without internet connection.',
                          child: DashboardCard(
                            title: 'JWT',
                            description:
                                'Decode and debug JSON Web Tokens (JWT) to verify token contents and ensure security it locally without internet connection.',
                            icon: const Icon(
                              Icons.code,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(8);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'Hash Generator | Generate cryptographic hashes for strings to ensure data integrity and security.',
                          child: DashboardCard(
                            title: 'Hash Generator',
                            description:
                                'Generate cryptographic hashes for strings to ensure data integrity and security.',
                            icon: const Icon(
                              Icons.fingerprint,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(9);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'Color Converter | Convert colors between different formats (HEX, RGB, HSL) for design and development purposes.',
                          child: DashboardCard(
                            title: 'Color Converter',
                            description:
                                'Convert colors between different formats (HEX, RGB, HSL) for design and development purposes.',
                            icon: const Icon(
                              Icons.color_lens,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(10);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'RegExp Tester | Test and debug regular expressions to ensure they match the intended patterns.',
                          child: DashboardCard(
                            title: 'RegExp Tester',
                            description:
                                'Test and debug regular expressions to ensure they match the intended patterns.',
                            icon: const Icon(
                              CupertinoIcons.textformat,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(11);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'Lorem Generator | Generate placeholder text for your projects to fill in design layouts.',
                          child: DashboardCard(
                            title: 'Lorem Generator',
                            description: 'Generate placeholder text for your projects to fill in design layouts.',
                            icon: const Icon(
                              CupertinoIcons.textbox,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(12);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'Password Generator | Create secure, random passwords to enhance security.',
                          child: DashboardCard(
                            title: 'Password Generator',
                            description: 'Create secure, random passwords to enhance security.',
                            icon: const Icon(
                              CupertinoIcons.lock,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(13);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'QR Code Generator | Generate QR codes from text or URLs for easy sharing and access.',
                          child: DashboardCard(
                            title: 'QR Code Generator',
                            description: 'Generate QR codes from text or URLs for easy sharing and access.',
                            icon: const Icon(
                              CupertinoIcons.qrcode,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(14);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'Image Formatter | Convert images between different file formats for compatibility and optimization.',
                          child: DashboardCard(
                            title: 'Image Formatter',
                            description:
                                'Convert images between different file formats for compatibility and optimization.',
                            icon: const Icon(
                              CupertinoIcons.photo_fill,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(15);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label:
                              'URL Encode/Decode | Encode and decode URLs to ensure proper formatting and transmission.',
                          child: DashboardCard(
                            title: 'URL Encode/Decode',
                            description: 'Encode and decode URLs to ensure proper formatting and transmission.',
                            icon: const Icon(
                              CupertinoIcons.globe,
                              size: 50,
                              color: Colors.white60,
                            ),
                            onTap: () {
                              sideMenu.changePage(16);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_dev/utils/tool_registry.dart';
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
                launchUrl(
                    Uri.parse('https://github.com/Jamalianpour/open-dev'));
              },
              customBorder: const CircleBorder(),
              child: Image.asset(
                'assets/images/github.png',
                width: 30,
                height: 30,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, ToolEntry tool, int pageIndex) {
    final iconTint = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
    final Widget cardIcon = tool.dashboardImagePath != null
        ? Image.asset(
            tool.dashboardImagePath!,
            width: 50,
            height: 50,
            color: iconTint,
          )
        : Icon(tool.icon, size: 50, color: iconTint);

    return Semantics(
      button: true,
      label: '${tool.title} | ${tool.description}',
      child: DashboardCard(
        title: tool.title,
        description: tool.description,
        icon: cardIcon,
        onTap: () => sideMenu.changePage(pageIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build (pageIndex, ToolEntry) pairs only for tools that opt in to the
    // dashboard. The pageIndex matches the position in BaseView's PageView,
    // which is `kTools.indexOf(tool) + 1` (the Dashboard itself is page 0).
    final entries = <(int, ToolEntry)>[
      for (int i = 0; i < kTools.length; i++)
        if (kTools[i].showOnDashboard) (i + 1, kTools[i]),
    ];

    return Column(
      children: [
        _buildHeader(context),
        const Divider(indent: 8, endIndent: 8),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 12),
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
                      const SizedBox(width: 6),
                      Text(
                        'Welcome to OpenDev! The Free and Open Source assistant for easier Coding',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Two columns on a wide window, one column when narrow.
                      final columns =
                          constraints.maxWidth < 600 ? 1 : 2;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          for (final (pageIndex, tool) in entries)
                            SizedBox(
                              width: columns == 1
                                  ? constraints.maxWidth
                                  : (constraints.maxWidth - 16) / 2,
                              child: _buildCard(context, tool, pageIndex),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

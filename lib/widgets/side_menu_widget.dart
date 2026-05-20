import 'dart:io';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_acrylic/widgets/transparent_macos_sidebar.dart';
import 'package:open_dev/utils/theme_notifier.dart';
import 'package:open_dev/utils/tool_registry.dart';
import 'package:open_dev/utils/user_prefs.dart';
import 'package:open_dev/widgets/command_palette.dart';

/// One row in the sidebar. The `pageIndex` is the position in the PageView
/// that this row navigates to — Dashboard is page 0, registry tools are
/// pages 1..N.
class _SidebarEntry {
  const _SidebarEntry(this.title, this.icon, this.pageIndex);
  final String title;
  final IconData icon;
  final int pageIndex;
}

List<_SidebarEntry> _buildEntries() {
  return [
    const _SidebarEntry('Dashboard', CupertinoIcons.home, 0),
    for (int i = 0; i < kTools.length; i++)
      _SidebarEntry(kTools[i].title, kTools[i].icon, i + 1),
  ];
}

class SideMenuWidget extends StatefulWidget {
  final SideMenuController sideMenu;
  const SideMenuWidget({super.key, required this.sideMenu});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_SidebarEntry> _matchingEntries(List<_SidebarEntry> entries) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return entries;
    return entries
        .where((e) => e.title.toLowerCase().contains(q))
        .toList(growable: false);
  }

  Widget _buildHeader(BuildContext context, {required bool compact}) {
    if (kIsWeb && !compact) {
      return Padding(
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
              Text('Open Dev',
                  style: Theme.of(context).textTheme.headlineLarge),
            ],
            const Spacer(),
            _PaletteButton(sideMenu: widget.sideMenu),
            _ThemeToggleButton(),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            compact ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        children: [
          if (!compact)
            const Text('Open Dev',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(mainAxisSize: MainAxisSize.min, children: [
            _PaletteButton(sideMenu: widget.sideMenu),
            _ThemeToggleButton(),
          ]),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search tools…',
          hintStyle: const TextStyle(fontSize: 13),
          prefixIcon: const Icon(CupertinoIcons.search, size: 16),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 32, minHeight: 32),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(CupertinoIcons.clear_circled_solid, size: 16),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 24, minHeight: 24),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
        onChanged: (v) => setState(() => _query = v),
      ),
    );
  }

  Widget _buildFilteredList(
      BuildContext context, List<_SidebarEntry> entries) {
    final matches = _matchingEntries(entries);
    final cs = Theme.of(context).colorScheme;
    if (matches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text('No tools match',
            style: TextStyle(
                color: cs.onSurface.withOpacity(0.5), fontSize: 13)),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, i) {
          final entry = matches[i];
          return InkWell(
            onTap: () {
              widget.sideMenu.changePage(entry.pageIndex);
              _searchController.clear();
              setState(() => _query = '');
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(entry.icon, size: 18, color: cs.onSurface),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(entry.title,
                        style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  SideMenu _buildSideMenu(BuildContext context,
      {required bool compact, required List<_SidebarEntry> entries}) {
    final items = <SideMenuItem>[
      for (final entry in entries)
        SideMenuItem(
          title: entry.title,
          icon: Icon(entry.icon),
          onTap: (index, _) {
            widget.sideMenu.changePage(index);
          },
        ),
    ];
    final cs = Theme.of(context).colorScheme;
    return SideMenu(
      controller: widget.sideMenu,
      items: items,
      title: Column(
        children: [
          _buildHeader(context, compact: compact),
          if (!compact) _buildSearchField(context),
          if (!compact)
            _PinnedAndRecentsBlock(sideMenu: widget.sideMenu),
        ],
      ),
      style: SideMenuStyle(
        itemHeight: 35,
        openSideMenuWidth: 250,
        compactSideMenuWidth: 60,
        displayMode: compact
            ? SideMenuDisplayMode.compact
            : SideMenuDisplayMode.open,
        selectedTitleTextStyle:
            TextStyle(fontSize: 14, color: cs.primary),
        unselectedTitleTextStyle:
            TextStyle(fontSize: 14, color: cs.onSurface.withOpacity(0.75)),
        selectedColor: cs.primaryContainer,
        hoverColor: Theme.of(context).hoverColor,
        iconSize: 20,
        selectedIconColor: cs.primary,
        unselectedIconColor: cs.onSurface.withOpacity(0.75),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 900;
    final entries = _buildEntries();

    Widget side() {
      // Compact (narrow) mode keeps the regular icon-only SideMenu — no search.
      if (compact || _query.isEmpty) {
        return _buildSideMenu(context, compact: compact, entries: entries);
      }
      // Open mode with active search → show plain filtered list.
      return SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, compact: false),
            _buildSearchField(context),
            _buildFilteredList(context, entries),
          ],
        ),
      );
    }

    // On macOS we want the native sidebar acrylic blur. Everywhere else
    // (Windows/Linux/Web) we paint our own themed surface so the sidebar
    // matches the page background instead of showing the bare window backing.
    if (!kIsWeb && Platform.isMacOS) {
      return TransparentMacOSSidebar(
        effect: WindowEffect.sidebar,
        child: side(),
      );
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? Colors.grey[850] : Colors.grey[200],
      child: side(),
    );
  }
}

/// Renders the Favorites and Recents sections above the main tool list.
/// Both sections render only when non-empty, so a fresh install sees nothing
/// here.
class _PinnedAndRecentsBlock extends StatelessWidget {
  const _PinnedAndRecentsBlock({required this.sideMenu});
  final SideMenuController sideMenu;

  @override
  Widget build(BuildContext context) {
    final prefs = UserPrefs.instance;
    return ValueListenableBuilder<List<String>>(
      valueListenable: prefs.favoritesListenable,
      builder: (context, favorites, _) {
        return ValueListenableBuilder<List<String>>(
          valueListenable: prefs.recentsListenable,
          builder: (context, recents, _) {
            if (favorites.isEmpty && recents.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (favorites.isNotEmpty)
                  _Section(
                    label: 'FAVORITES',
                    titles: favorites,
                    sideMenu: sideMenu,
                    isFavoriteSection: true,
                  ),
                if (recents.isNotEmpty)
                  _Section(
                    label: 'RECENT',
                    titles: recents,
                    sideMenu: sideMenu,
                    isFavoriteSection: false,
                  ),
                const Divider(height: 8),
              ],
            );
          },
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.titles,
    required this.sideMenu,
    required this.isFavoriteSection,
  });

  final String label;
  final List<String> titles;
  final SideMenuController sideMenu;
  final bool isFavoriteSection;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: cs.onSurface.withOpacity(0.5),
            ),
          ),
        ),
        for (final title in titles)
          _SectionRow(
            title: title,
            sideMenu: sideMenu,
            showUnstar: isFavoriteSection,
          ),
      ],
    );
  }
}

class _SectionRow extends StatefulWidget {
  const _SectionRow({
    required this.title,
    required this.sideMenu,
    required this.showUnstar,
  });

  final String title;
  final SideMenuController sideMenu;
  final bool showUnstar;

  @override
  State<_SectionRow> createState() => _SectionRowState();
}

class _SectionRowState extends State<_SectionRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final pageIndex = UserPrefs.instance.pageIndexFor(widget.title);
    final tool = pageIndex == null ? null : kTools[pageIndex - 1];
    if (pageIndex == null || tool == null) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        onTap: () => widget.sideMenu.changePage(pageIndex),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: _hover ? Theme.of(context).hoverColor : null,
          child: Row(
            children: [
              Icon(tool.icon,
                  size: 16, color: cs.onSurface.withOpacity(0.85)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  tool.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              if (widget.showUnstar && _hover)
                InkWell(
                  onTap: () =>
                      UserPrefs.instance.toggleFavorite(widget.title),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(CupertinoIcons.star_fill,
                        size: 14, color: cs.primary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaletteButton extends StatelessWidget {
  const _PaletteButton({required this.sideMenu});
  final SideMenuController sideMenu;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Open command palette (⌘K / Ctrl+K)',
      iconSize: 18,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      icon: const Icon(CupertinoIcons.command),
      onPressed: () async {
        final picked = await showCommandPalette(context);
        if (picked != null) sideMenu.changePage(picked);
      },
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          tooltip: isDark ? 'Switch to light theme' : 'Switch to dark theme',
          iconSize: 18,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          icon: Icon(isDark ? CupertinoIcons.sun_max : CupertinoIcons.moon),
          onPressed: toggleThemeMode,
        );
      },
    );
  }
}

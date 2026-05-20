import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/tool_registry.dart';
import 'package:open_dev/utils/user_prefs.dart';

/// Shows the command palette as a centered modal. Returns the chosen page
/// index when the user picks a tool, or `null` if dismissed.
///
/// Page 0 is the Dashboard; tools occupy 1..N matching `kTools` order.
Future<int?> showCommandPalette(BuildContext context) {
  return showGeneralDialog<int>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss command palette',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 120),
    pageBuilder: (context, _, __) => const _CommandPaletteDialog(),
    transitionBuilder: (context, anim, _, child) {
      final curved =
          CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.96, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Wraps the app shell in an [Actions] / [Shortcuts] pair so the palette
/// can be triggered globally with ⌘K (macOS) / Ctrl+K (everywhere else).
class CommandPaletteHost extends StatelessWidget {
  const CommandPaletteHost({
    super.key,
    required this.sideMenu,
    required this.child,
  });

  final SideMenuController sideMenu;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.keyK, meta: true):
            _OpenPaletteIntent(),
        SingleActivator(LogicalKeyboardKey.keyK, control: true):
            _OpenPaletteIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _OpenPaletteIntent: CallbackAction<_OpenPaletteIntent>(
            onInvoke: (_) async {
              final picked = await showCommandPalette(context);
              if (picked != null) sideMenu.changePage(picked);
              return null;
            },
          ),
        },
        child: Focus(autofocus: true, child: child),
      ),
    );
  }
}

class _OpenPaletteIntent extends Intent {
  const _OpenPaletteIntent();
}

class _PaletteItem {
  const _PaletteItem({
    required this.title,
    required this.icon,
    required this.pageIndex,
    this.subtitle,
  });
  final String title;
  final IconData icon;
  final int pageIndex;
  final String? subtitle;
}

List<_PaletteItem> _allItems() => [
      const _PaletteItem(
          title: 'Dashboard',
          icon: CupertinoIcons.home,
          pageIndex: 0,
          subtitle: 'Home'),
      for (int i = 0; i < kTools.length; i++)
        _PaletteItem(
          title: kTools[i].title,
          icon: kTools[i].icon,
          pageIndex: i + 1,
          subtitle: kTools[i].description,
        ),
    ];

class _CommandPaletteDialog extends StatefulWidget {
  const _CommandPaletteDialog();

  @override
  State<_CommandPaletteDialog> createState() => _CommandPaletteDialogState();
}

class _CommandPaletteDialogState extends State<_CommandPaletteDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();
  String _query = '';
  int _highlighted = 0;

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  List<_PaletteItem> get _filtered {
    final q = _query.trim().toLowerCase();
    final all = _allItems();
    if (q.isEmpty) return all;

    // Score each item: prefix-match wins, contains-match next, otherwise drop.
    // Subtitle matches score lower than title matches.
    final scored = <(_PaletteItem, int)>[];
    for (final item in all) {
      final title = item.title.toLowerCase();
      final sub = item.subtitle?.toLowerCase() ?? '';
      int score;
      if (title.startsWith(q)) {
        score = 100;
      } else if (title.contains(q)) {
        score = 70;
      } else if (sub.contains(q)) {
        score = 30;
      } else if (_subsequenceMatch(title, q)) {
        score = 10;
      } else {
        continue;
      }
      scored.add((item, score));
    }
    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return scored.map((e) => e.$1).toList(growable: false);
  }

  bool _subsequenceMatch(String haystack, String needle) {
    int i = 0;
    for (final c in haystack.runes) {
      if (i >= needle.length) return true;
      if (String.fromCharCode(c) == needle[i]) i++;
    }
    return i >= needle.length;
  }

  void _move(int delta) {
    final n = _filtered.length;
    if (n == 0) return;
    setState(() {
      _highlighted = (_highlighted + delta) % n;
      if (_highlighted < 0) _highlighted += n;
    });
  }

  void _select(int index) {
    final list = _filtered;
    if (index < 0 || index >= list.length) return;
    Navigator.of(context).pop(list[index].pageIndex);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        _move(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _move(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
        _select(_highlighted);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        Navigator.of(context).pop();
        return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = _filtered;
    if (_highlighted >= items.length) _highlighted = items.isEmpty ? 0 : 0;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 560,
            constraints: const BoxConstraints(maxHeight: 480),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Focus(
              focusNode: _focus,
              autofocus: true,
              onKeyEvent: _onKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.search,
                            size: 18,
                            color: cs.onSurface.withOpacity(0.7)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'Type to search tools…',
                            ),
                            style: const TextStyle(fontSize: 15),
                            onChanged: (v) {
                              setState(() {
                                _query = v;
                                _highlighted = 0;
                              });
                            },
                            onSubmitted: (_) => _select(_highlighted),
                          ),
                        ),
                        _KeyHint(label: 'esc', cs: cs),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: cs.outlineVariant),
                  Flexible(
                    child: items.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'No matches.',
                              style: TextStyle(
                                  color: cs.onSurface.withOpacity(0.6)),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            itemCount: items.length,
                            itemBuilder: (context, i) {
                              final item = items[i];
                              final highlighted = i == _highlighted;
                              return MouseRegion(
                                onEnter: (_) =>
                                    setState(() => _highlighted = i),
                                child: InkWell(
                                  onTap: () => _select(i),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    color: highlighted
                                        ? cs.primaryContainer
                                            .withOpacity(0.35)
                                        : null,
                                    child: Row(
                                      children: [
                                        Icon(item.icon,
                                            size: 18,
                                            color: highlighted
                                                ? cs.primary
                                                : cs.onSurface),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(item.title,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              if (item.subtitle != null)
                                                Text(
                                                  item.subtitle!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: cs.onSurface
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        if (item.pageIndex > 0)
                                          _FavoriteStar(title: item.title),
                                        if (highlighted) ...[
                                          const SizedBox(width: 4),
                                          _KeyHint(label: '↵', cs: cs),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: cs.outlineVariant)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    child: Row(
                      children: [
                        _KeyHint(label: '↑↓', cs: cs),
                        const SizedBox(width: 4),
                        Text('navigate',
                            style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurface.withOpacity(0.6))),
                        const SizedBox(width: 12),
                        _KeyHint(label: '↵', cs: cs),
                        const SizedBox(width: 4),
                        Text('open',
                            style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurface.withOpacity(0.6))),
                        const Spacer(),
                        Text('${items.length} result${items.length == 1 ? '' : 's'}',
                            style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurface.withOpacity(0.6))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteStar extends StatelessWidget {
  const _FavoriteStar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ValueListenableBuilder<List<String>>(
      valueListenable: UserPrefs.instance.favoritesListenable,
      builder: (context, favorites, _) {
        final isFavorite = favorites.contains(title);
        return InkWell(
          onTap: () => UserPrefs.instance.toggleFavorite(title),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              isFavorite ? CupertinoIcons.star_fill : CupertinoIcons.star,
              size: 14,
              color: isFavorite
                  ? cs.primary
                  : cs.onSurface.withOpacity(0.45),
            ),
          ),
        );
      },
    );
  }
}

class _KeyHint extends StatelessWidget {
  const _KeyHint({required this.label, required this.cs});
  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(label,
          style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: cs.onSurface.withOpacity(0.8))),
    );
  }
}

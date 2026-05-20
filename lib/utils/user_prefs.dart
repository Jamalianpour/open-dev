import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tool_registry.dart';

/// Persisted user state: favorites (pinned tools) and recents (last-used).
///
/// Keys are tool titles from [kTools] — stable enough for this single-app use
/// case and avoids leaking integer page indices that change when [kTools] is
/// reordered.
class UserPrefs {
  UserPrefs._();
  static final UserPrefs instance = UserPrefs._();

  static const _kFavorites = 'favorites_v1';
  static const _kRecents = 'recents_v1';
  static const int maxRecents = 5;

  SharedPreferences? _prefs;

  /// Snapshot of favorited tool titles, in user-defined order. Listened to by
  /// [favoritesListenable].
  final ValueNotifier<List<String>> favoritesListenable =
      ValueNotifier<List<String>>(const []);

  /// Snapshot of recently-opened tool titles, most-recent first. Listened to by
  /// [recentsListenable].
  final ValueNotifier<List<String>> recentsListenable =
      ValueNotifier<List<String>>(const []);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    favoritesListenable.value =
        _filterKnown(_prefs!.getStringList(_kFavorites) ?? const []);
    recentsListenable.value =
        _filterKnown(_prefs!.getStringList(_kRecents) ?? const []);
  }

  /// Drops titles that no longer exist in [kTools] (e.g. after a rename).
  List<String> _filterKnown(List<String> titles) {
    final known = kTools.map((t) => t.title).toSet();
    return titles.where(known.contains).toList(growable: false);
  }

  bool isFavorite(String title) =>
      favoritesListenable.value.contains(title);

  Future<void> toggleFavorite(String title) async {
    final current = List<String>.from(favoritesListenable.value);
    if (current.contains(title)) {
      current.remove(title);
    } else {
      current.add(title);
    }
    favoritesListenable.value = current;
    await _prefs?.setStringList(_kFavorites, current);
  }

  /// Records a tool as opened. The Dashboard is not tracked.
  Future<void> recordOpen(String title) async {
    if (!kTools.any((t) => t.title == title)) return;
    final current = List<String>.from(recentsListenable.value);
    current.remove(title);
    current.insert(0, title);
    if (current.length > maxRecents) {
      current.removeRange(maxRecents, current.length);
    }
    recentsListenable.value = current;
    await _prefs?.setStringList(_kRecents, current);
  }

  /// Looks up a tool's `pageIndex` (1-based) by title. Returns `null` if not
  /// present in the current registry.
  int? pageIndexFor(String title) {
    final i = kTools.indexWhere((t) => t.title == title);
    return i < 0 ? null : i + 1;
  }
}

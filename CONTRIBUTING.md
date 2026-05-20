# Contributing to Open Dev

Thanks for considering a contribution! Open Dev is a developer toolbox built with Flutter, targeting macOS, Windows, Linux, and Web. This guide is the shortest path to a green PR.

## Project setup

```sh
flutter pub get             # install deps
flutter run -d macos        # run on macOS
flutter run -d chrome       # run in browser (no signing required)
flutter analyze             # lint
flutter test                # run all tests
flutter test test/case_utils_test.dart   # one file
```

Continuous integration runs `flutter analyze` and `flutter test` on every PR — please make sure both pass locally first.

## Adding a new tool

Every tool is described in **one place**: [`lib/utils/tool_registry.dart`](lib/utils/tool_registry.dart). The sidebar, the PageView, the dashboard, and the command palette all read from that single list, so the only sync you have to maintain is at the registry entry.

1. **Pure logic** → create `lib/utils/{name}_utils.dart`. Plain Dart, no Flutter imports. Single class with static methods is the convention.
2. **UI** → create `lib/views/{name}_view.dart`. A `StatefulWidget` that owns its own controllers/state. Look at [`lib/views/case_view.dart`](lib/views/case_view.dart) for the simplest template, or [`lib/views/diff_view.dart`](lib/views/diff_view.dart) for a two-pane layout.
3. **Register** → append one `ToolEntry` to `kTools` in [`lib/utils/tool_registry.dart`](lib/utils/tool_registry.dart):
   ```dart
   ToolEntry(
     title: 'My Tool',
     icon: CupertinoIcons.wrench,
     description: 'One-sentence pitch shown on the dashboard card.',
     builder: () => const MyToolView(),
   ),
   ```
4. **Test** → add `test/{name}_utils_test.dart` for the pure logic. Browse the existing tests for shape.

That's it. The sidebar entry, PageView page, dashboard card, search index, and command-palette entry all appear automatically.

## Patterns and conventions

- **Sidebar / PageView ordering** — set by the order of entries in `kTools`. Don't try to keep numeric page indices in sync; nothing else references them.
- **Shared widgets** in `lib/widgets/`:
  - `DataWidget` — read-only labeled value box with a copy button
  - `EditableDataWidget` — editable variant
  - `ErrorNotificationWidget` — animated error banner
- **Code editors** — for any text bigger than a single field, use `re_editor` with the `stackoverflowDarkTheme` from `lib/utils/theme.dart`. See `json_view.dart`.
- **File pickers** — call `FilePicker.pickFiles(withData: true)` (static method, not `FilePicker.platform.pickFiles` — that's the older API). Use `result.files.single.bytes` so it works on web too.
- **Dark / light theme** — both must look good. Use `Theme.of(context).colorScheme.*` for colors, not hard-coded values. The theme toggle lives in the sidebar header.
- **Persistence** — for any new user preference, extend `lib/utils/user_prefs.dart` (backed by `shared_preferences`).

## Things to avoid

- Don't import `dart:io` in code that should run on Web. Gate desktop-only paths on `!kIsWeb`.
- Don't add a new dependency unless an equivalent isn't already in `pubspec.yaml` — the project carries a wide surface (`crypto`, `xml`, `yaml`, `image`, `file_picker`, …) on purpose.
- Don't hardcode the page index of a tool. Use `kTools.indexOf(tool) + 1` (or `UserPrefs.instance.pageIndexFor(title)`).
- Don't commit your `DEVELOPMENT_TEAM` ID into `macos/Runner.xcodeproj/project.pbxproj` — the team in HEAD is the maintainer's. Use Xcode's "Automatically manage signing" with your own personal team during development, but don't push that change.

## Pull requests

- Keep PRs focused — one new tool or one logical change.
- Update or add tests if the change touches `lib/utils/*` (pure logic).
- Make sure `flutter analyze` (no errors, no new warnings) and `flutter test` pass locally.
- If you change behavior of an existing tool, please mention it in the PR description so the README and screenshots can be refreshed.

## Issues

When reporting a bug, include:
- Platform (macOS / Windows / Linux / Web + version)
- Flutter version (`flutter --version`)
- Minimal repro steps
- What you expected vs. what happened

## License

By contributing you agree that your contributions will be licensed under the same [MIT License](LICENSE) that covers the rest of the project.

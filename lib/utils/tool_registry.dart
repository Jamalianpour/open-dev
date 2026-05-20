import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../views/base64_view.dart';
import '../views/case_view.dart';
import '../views/color_view.dart';
import '../views/cron_view.dart';
import '../views/csv_view.dart';
import '../views/dart_class_view.dart';
import '../views/diff_view.dart';
import '../views/file_hash_view.dart';
import '../views/hash_view.dart';
import '../views/hex_view.dart';
import '../views/html_view.dart';
import '../views/image_view.dart';
import '../views/json_view.dart';
import '../views/jwt_view.dart';
import '../views/lorem_view.dart';
import '../views/news_view.dart';
import '../views/number_base_view.dart';
import '../views/password_view.dart';
import '../views/qr_view.dart';
import '../views/readme_view.dart';
import '../views/regex_view.dart';
import '../views/sql_view.dart';
import '../views/unix_time_view.dart';
import '../views/url_view.dart';
import '../views/uuid_view.dart';
import '../views/xml_view.dart';
import '../views/yaml_view.dart';

/// Describes a single tool. The order of [kTools] defines the order of tools
/// in the sidebar, the PageView, and on the dashboard. All three consumers
/// read this list so adding a new tool only requires one entry.
class ToolEntry {
  const ToolEntry({
    required this.title,
    required this.icon,
    required this.description,
    required this.builder,
    this.dashboardImagePath,
    this.showOnDashboard = true,
  });

  /// Sidebar label and dashboard card heading.
  final String title;

  /// Sidebar icon. Also used as the dashboard icon unless
  /// [dashboardImagePath] is set.
  final IconData icon;

  /// One-sentence description shown on the dashboard card.
  final String description;

  /// Builds the tool's view. Called from the PageView.
  final Widget Function() builder;

  /// Optional asset path that overrides [icon] on the dashboard card.
  final String? dashboardImagePath;

  /// Set to `false` to hide this tool from the dashboard (but keep it in the
  /// sidebar and PageView).
  final bool showOnDashboard;
}

/// Single source of truth for every tool. Sidebar position `i+1` and PageView
/// index `i+1` always map to `kTools[i]` (position 0 is the Dashboard).
final List<ToolEntry> kTools = [
  ToolEntry(
    title: 'Json',
    icon: Icons.code,
    description:
        'Master Your JSON! Format, minify, parse, validate, and convert it to Yaml with ease.',
    dashboardImagePath: 'assets/images/json.png',
    builder: () => const JsonView(),
  ),
  ToolEntry(
    title: 'XML',
    icon: CupertinoIcons.chevron_left_slash_chevron_right,
    description:
        'Play with XML. Format, parse, validate, and convert it to Json with ease.',
    dashboardImagePath: 'assets/images/xml.png',
    builder: () => const XmlView(),
  ),
  ToolEntry(
    title: 'Cron',
    icon: CupertinoIcons.timer,
    description:
        'Interpret and validate cron expressions to ensure correct scheduling of automated tasks.',
    builder: () => const CronView(),
  ),
  ToolEntry(
    title: 'Unix Time',
    icon: CupertinoIcons.time,
    description:
        'Convert Unix timestamps to human-readable dates and vice versa, simplifying the handling of time data.',
    builder: () => const UnixTimeView(),
  ),
  ToolEntry(
    title: 'Markdown',
    icon: CupertinoIcons.doc_text,
    description:
        'Create and preview README files in real-time to ensure your documentation looks perfect.',
    builder: () => const ReadmeView(),
  ),
  ToolEntry(
    title: 'Developer News',
    icon: CupertinoIcons.news,
    description:
        'Stay updated with the latest developer news through RSS feeds from popular sources.',
    builder: () => const NewsView(),
  ),
  ToolEntry(
    title: 'Base64',
    icon: CupertinoIcons.text_alignleft,
    description:
        'Encode and decode Base64 strings and images for data processing and transmission.',
    builder: () => const Base64View(),
  ),
  ToolEntry(
    title: 'JWT',
    icon: Icons.code,
    description:
        'Decode and debug JSON Web Tokens (JWT) to verify token contents and ensure security locally without internet connection.',
    builder: () => const JwtView(),
  ),
  ToolEntry(
    title: 'Hash',
    icon: Icons.fingerprint,
    description:
        'Generate cryptographic hashes for strings to ensure data integrity and security.',
    builder: () => const HashView(),
  ),
  ToolEntry(
    title: 'Color Picker',
    icon: Icons.color_lens,
    description:
        'Convert colors between different formats (HEX, RGB, HSL, CMYK, HSB) for design and development purposes.',
    builder: () => const ColorView(),
  ),
  ToolEntry(
    title: 'RegExp Tester',
    icon: CupertinoIcons.textformat,
    description:
        'Test and debug regular expressions to ensure they match the intended patterns.',
    builder: () => const RegexView(),
  ),
  ToolEntry(
    title: 'Lorem ipsum',
    icon: CupertinoIcons.textbox,
    description:
        'Generate placeholder text for your projects to fill in design layouts.',
    builder: () => const LoremView(),
  ),
  ToolEntry(
    title: 'Password',
    icon: CupertinoIcons.lock,
    description: 'Create secure, random passwords to enhance security.',
    builder: () => const PasswordView(),
  ),
  ToolEntry(
    title: 'QR Code',
    icon: CupertinoIcons.qrcode,
    description: 'Generate QR codes from text or URLs for easy sharing and access.',
    builder: () => const QrView(),
  ),
  ToolEntry(
    title: 'Image Format',
    icon: CupertinoIcons.photo_fill,
    description:
        'Convert images between different file formats for compatibility and optimization.',
    builder: () => const ImageView(),
  ),
  ToolEntry(
    title: 'URL Parser',
    icon: CupertinoIcons.globe,
    description: 'Encode and decode URLs to ensure proper formatting and transmission.',
    builder: () => const UrlView(),
  ),
  ToolEntry(
    title: 'UUID Generator/Decode',
    icon: CupertinoIcons.underline,
    description:
        'Generate and decode UUIDs (Universally Unique Identifiers) for applications that require unique identifiers.',
    builder: () => const UuidView(),
  ),
  ToolEntry(
    title: 'Number Base',
    icon: CupertinoIcons.number,
    description:
        'Convert numbers between binary, octal, decimal, and hex with a bit grid and bitwise operations.',
    builder: () => const NumberBaseView(),
  ),
  ToolEntry(
    title: 'Case Converter',
    icon: CupertinoIcons.textformat_abc,
    description:
        'Convert identifiers between camelCase, snake_case, kebab-case, PascalCase, and more.',
    builder: () => const CaseView(),
  ),
  ToolEntry(
    title: 'Text / JSON Diff',
    icon: CupertinoIcons.doc_on_doc,
    description:
        'Compare two pieces of text or JSON side by side with line-level highlighting.',
    builder: () => const DiffView(),
  ),
  ToolEntry(
    title: 'HTML Encode/Decode',
    icon: CupertinoIcons.chevron_left_slash_chevron_right,
    description:
        'Escape and unescape HTML entities — supports element and attribute-safe modes.',
    builder: () => const HtmlView(),
  ),
  ToolEntry(
    title: 'YAML → JSON',
    icon: CupertinoIcons.arrow_right_arrow_left,
    description: 'Convert YAML documents into pretty-printed JSON.',
    builder: () => const YamlView(),
  ),
  ToolEntry(
    title: 'CSV ↔ JSON',
    icon: CupertinoIcons.table,
    description:
        'Convert CSV ⇄ JSON with table preview, configurable delimiter, and scalar coercion.',
    builder: () => const CsvView(),
  ),
  ToolEntry(
    title: 'SQL Formatter',
    icon: CupertinoIcons.layers,
    description: 'Pretty-print and minify SQL statements.',
    builder: () => const SqlView(),
  ),
  ToolEntry(
    title: 'File Hash',
    icon: CupertinoIcons.shield,
    description:
        'Compute MD5, SHA-1, SHA-256, SHA-384 and SHA-512 checksums of any file, with hash verification.',
    builder: () => const FileHashView(),
  ),
  ToolEntry(
    title: 'Hex Viewer',
    icon: CupertinoIcons.doc_text_search,
    description:
        'View the raw bytes of any file as a classic offset / hex / ASCII dump.',
    builder: () => const HexView(),
  ),
  ToolEntry(
    title: 'JSON → Dart class',
    icon: CupertinoIcons.cube,
    description:
        'Generate null-safe Dart model classes from a JSON sample, with fromJson and toJson.',
    builder: () => const DartClassView(),
  ),
];

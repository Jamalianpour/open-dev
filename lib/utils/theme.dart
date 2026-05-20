import 'package:flutter/material.dart';

const stackoverflowDarkTheme = {
  'root':
      TextStyle(color: Color(0xffffffff), backgroundColor: Color(0xff1c1b1b)),
  'subst': TextStyle(color: Color(0xffffffff)),
  'comment': TextStyle(color: Color(0xff999999)),
  'keyword': TextStyle(color: Color(0xff88aece)),
  'selector-tag': TextStyle(color: Color(0xff88aece)),
  'meta-keyword': TextStyle(color: Color(0xff88aece)),
  'doctag': TextStyle(color: Color(0xff88aece)),
  'section': TextStyle(color: Color(0xff88aece)),
  'attr': TextStyle(color: Color(0xff88aece)),
  'attribute': TextStyle(color: Color(0xffc59bc1)),
  'name': TextStyle(color: Color(0xfff08d49)),
  'type': TextStyle(color: Color(0xfff08d49)),
  'number': TextStyle(color: Color(0xfff08d49)),
  'selector-id': TextStyle(color: Color(0xfff08d49)),
  'quote': TextStyle(color: Color(0xfff08d49)),
  'template-tag': TextStyle(color: Color(0xfff08d49)),
  'selector-class': TextStyle(color: Color(0xff88aece)),
  'string': TextStyle(color: Color(0xffb5bd68)),
  'regexp': TextStyle(color: Color(0xffb5bd68)),
  'symbol': TextStyle(color: Color(0xffb5bd68)),
  'variable': TextStyle(color: Color(0xffb5bd68)),
  'template-variable': TextStyle(color: Color(0xffb5bd68)),
  'link': TextStyle(color: Color(0xffb5bd68)),
  'selector-attr': TextStyle(color: Color(0xffb5bd68)),
  'meta': TextStyle(color: Color(0xff88aece)),
  'selector-pseudo': TextStyle(color: Color(0xff88aece)),
  'built_in': TextStyle(color: Color(0xfff08d49)),
  'title': TextStyle(color: Color(0xfff08d49)),
  'literal': TextStyle(color: Color(0xfff08d49)),
  'bullet': TextStyle(color: Color(0xffcccccc)),
  'code': TextStyle(color: Color(0xffcccccc)),
  'meta-string': TextStyle(color: Color(0xffb5bd68)),
  'deletion': TextStyle(color: Color(0xffde7176)),
  'addition': TextStyle(color: Color(0xff76c490)),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'strong': TextStyle(fontWeight: FontWeight.bold),
};

/// VS Code-flavoured light theme for `re_highlight`. Mirrors the dark variant
/// key-for-key so the editor swap is a clean substitution.
const stackoverflowLightTheme = {
  'root':
      TextStyle(color: Color(0xff24292e), backgroundColor: Color(0xfff8f8f8)),
  'subst': TextStyle(color: Color(0xff24292e)),
  'comment': TextStyle(color: Color(0xff6a737d)),
  'keyword': TextStyle(color: Color(0xff0451a5)),
  'selector-tag': TextStyle(color: Color(0xff0451a5)),
  'meta-keyword': TextStyle(color: Color(0xff0451a5)),
  'doctag': TextStyle(color: Color(0xff0451a5)),
  'section': TextStyle(color: Color(0xff0451a5)),
  'attr': TextStyle(color: Color(0xff0451a5)),
  'attribute': TextStyle(color: Color(0xff6f42c1)),
  'name': TextStyle(color: Color(0xff098658)),
  'type': TextStyle(color: Color(0xff098658)),
  'number': TextStyle(color: Color(0xff098658)),
  'selector-id': TextStyle(color: Color(0xff098658)),
  'quote': TextStyle(color: Color(0xff098658)),
  'template-tag': TextStyle(color: Color(0xff098658)),
  'selector-class': TextStyle(color: Color(0xff0451a5)),
  'string': TextStyle(color: Color(0xffa31515)),
  'regexp': TextStyle(color: Color(0xffa31515)),
  'symbol': TextStyle(color: Color(0xffa31515)),
  'variable': TextStyle(color: Color(0xffa31515)),
  'template-variable': TextStyle(color: Color(0xffa31515)),
  'link': TextStyle(color: Color(0xffa31515)),
  'selector-attr': TextStyle(color: Color(0xffa31515)),
  'meta': TextStyle(color: Color(0xff0451a5)),
  'selector-pseudo': TextStyle(color: Color(0xff0451a5)),
  'built_in': TextStyle(color: Color(0xff098658)),
  'title': TextStyle(color: Color(0xff098658)),
  'literal': TextStyle(color: Color(0xff098658)),
  'bullet': TextStyle(color: Color(0xff586069)),
  'code': TextStyle(color: Color(0xff586069)),
  'meta-string': TextStyle(color: Color(0xffa31515)),
  'deletion': TextStyle(color: Color(0xffb31d28)),
  'addition': TextStyle(color: Color(0xff22863a)),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'strong': TextStyle(fontWeight: FontWeight.bold),
};

/// Picks the right `re_highlight` theme for the current Material brightness.
Map<String, TextStyle> editorThemeOf(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? stackoverflowDarkTheme
      : stackoverflowLightTheme;
}

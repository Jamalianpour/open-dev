import 'package:re_editor/re_editor.dart';

class RegexUtils {
  List<String> getRegexMatches(CodeFindValue value) {
    List<String> matches = [];
    for (var i = 0; i < (value.result?.matches.length ?? 0); i++) {
      matches.add(value.result?.codeLines[value.result?.matches[i].startIndex ?? 0]
              .substring(value.result!.matches[i].startOffset, value.result?.matches[i].endOffset) ??
          '');
    }
    return matches;
  }
}

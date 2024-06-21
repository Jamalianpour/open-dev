import 'package:flutter/material.dart';
import 'package:open_dev/utils/regex_utils.dart';
import 'package:open_dev/widgets/regex/regex_cheat_sheet.dart';
import 'package:open_dev/widgets/secondary_button.dart';
import 'package:re_editor/re_editor.dart';

import '../widgets/regex/regex_input_widget.dart';

class RegexView extends StatefulWidget {
  const RegexView({super.key});

  @override
  State<RegexView> createState() => _RegexViewState();
}

class _RegexViewState extends State<RegexView> {
  final CodeLineEditingController _controller = CodeLineEditingController();
  late CodeFindController _findController;
  RegexUtils regexUtils = RegexUtils();
  List<String> matches = [];

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('RegExp Tester', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
          // SecondaryButton(
          //     text: 'Example',
          //     onTap: () {
          //       _findController = CodeFindController(
          //           _controller,
          //           CodeFindValue(
          //               option: CodeFindOption(
          //                   caseSensitive: true, regex: true, pattern: '[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}'),
          //               replaceMode: false));
          //       setState(() {});
          //     }),
          SecondaryButton(
            text: 'Cheat Sheet',
            onTap: () {
              showModalBottomSheet(
                  showDragHandle: true,
                  context: context,
                  builder: (context) => const RegexCheatSheet(),
                  constraints: const BoxConstraints(maxHeight: 500, maxWidth: 600),
                  isScrollControlled: true);
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _findController = CodeFindController(_controller);
    _findController.findMode();
    _findController.toggleRegex();
    _findController.toggleCaseSensitive();
    _findController.addListener(
      () {
        if (_findController.value != null) {
          if (_findController.value!.result != null) {
            matches = regexUtils.getRegexMatches(_findController.value!);
            if (matches.isNotEmpty) {
              setState(() {});
            }
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const Divider(
          indent: 8,
          endIndent: 8,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Theme.of(context).focusColor,
              ),
              child: CodeEditor(
                style: CodeEditorStyle(
                  fontSize: 14,
                  fontHeight: 1.5,
                  selectionColor: Theme.of(context).colorScheme.primaryContainer,
                ),
                controller: _controller,
                wordWrap: true,
                findController: _findController,
                findBuilder: (context, controller, readOnly) => RegexInputWidget(
                  controller: controller,
                  readOnly: readOnly,
                ),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Matches',
              style: TextStyle(
                fontSize: 16,
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: 200,
            child: matches.isEmpty
                ? Center(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Theme.of(context).focusColor,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            'No matches found!!! 🧐',
                            style: TextStyle(fontSize: 16),
                          ),
                        )),
                  )
                : SingleChildScrollView(
                    child: Wrap(
                      children: [
                        for (int i = 0; i < matches.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Chip(
                              label: Text(matches[i]),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:open_dev/utils/markdwon_utils.dart';
import 'package:re_editor/re_editor.dart';

class ReadmeView extends StatefulWidget {
  const ReadmeView({super.key});

  @override
  State<ReadmeView> createState() => _ReadmeViewState();
}

class _ReadmeViewState extends State<ReadmeView> {
  final CodeLineEditingController controller = CodeLineEditingController();
  final List<bool> openSides = [true, true];

  @override
  void initState() {
    controller.text = MarkdownUtils.sampleText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Text('Readme helper', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              ToggleButtons(
                isSelected: openSides,
                onPressed: (index) {
                  openSides[index] = !openSides[index];
                  if (!openSides[0] && !openSides[1]) {
                    openSides[0] = true;
                    openSides[1] = true;
                  }
                  setState(() {});
                },
                constraints: const BoxConstraints(minHeight: 30, minWidth: 35),
                children: const [
                  Icon(CupertinoIcons.square_righthalf_fill),
                  Icon(CupertinoIcons.square_lefthalf_fill),
                ],
              )
            ],
          ),
        ),
        const Divider(
          indent: 8,
          endIndent: 8,
        ),
        Expanded(
          child: Row(
            children: [
              if (openSides[0])
                Expanded(
                  child: CodeEditor(
                    controller: controller,
                    onChanged: (value) {
                      if (openSides[1]) {
                        setState(() {});
                      }
                    },
                    indicatorBuilder: (context, editingController, chunkController, notifier) {
                      return Row(
                        children: [
                          DefaultCodeLineNumber(
                            controller: editingController,
                            notifier: notifier,
                          ),
                        ],
                      );
                    },
                    sperator: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Container(width: 1, color: Colors.blue),
                    ),
                  ),
                ),
              if (openSides[1] && openSides[0]) const VerticalDivider(),
              if (openSides[1])
                Expanded(
                  child: MarkdownWidget(
                    data: controller.text,
                    config: MarkdownConfig(configs: [PreConfig.darkConfig]),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:open_dev/utils/json_utils.dart';
import 'package:open_dev/widgets/json/json_viewer_widget.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
// import 'package:re_highlight/styles/atom-one-dark.dart';
// import 'package:re_highlight/styles/github-dark.dart';
// import 'package:re_highlight/styles/stackoverflow-dark.dart';
// import 'package:flutter_json_view/flutter_json_view.dart' as viewer;

import '../utils/theme.dart';
import '../widgets/error_notification_widget.dart';
import '../widgets/json/json_find_widget.dart';

class JsonView extends StatefulWidget {
  const JsonView({super.key});

  @override
  State<JsonView> createState() => _JsonViewState();
}

class _JsonViewState extends State<JsonView> {
  final CodeLineEditingController _controller = CodeLineEditingController();
  final CodeLineEditingController _yamlViewer = CodeLineEditingController();
  String jsonToView = '{"key":"value"}';
  String errorMessage = '';
  late CodeFindController _findController;
  bool convertToYamlMode = false;

  @override
  void initState() {
    _findController = CodeFindController(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('Json parser', style: Theme.of(context).textTheme.headlineSmall),
        ),
        const Divider(endIndent: 8, indent: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                          // color: Theme.of(context).colorScheme.background,
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  try {
                                    _controller.text = prettyJson(_controller.text);
                                    setState(() {
                                      errorMessage = '';
                                    });
                                  } catch (e) {
                                    setState(() {
                                      errorMessage = e.toString();
                                    });
                                  }
                                },
                                child: const Text('pretty'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  try {
                                    _controller.text = minifyJson(_controller.text);
                                    errorMessage = '';
                                  } catch (e) {
                                    errorMessage = e.toString();
                                  }
                                },
                                child: const Text('minify'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  _findController.findMode();
                                },
                                child: const Text('find'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: CodeEditor(
                            style: CodeEditorStyle(
                              codeTheme: CodeHighlightTheme(
                                languages: {
                                  'json': CodeHighlightThemeMode(mode: langJson),
                                },
                                theme: stackoverflowDarkTheme,
                              ),
                            ),
                            controller: _controller,
                            wordWrap: true,
                            indicatorBuilder: (context, editingController, chunkController, notifier) {
                              return Row(
                                children: [
                                  DefaultCodeLineNumber(
                                    controller: editingController,
                                    notifier: notifier,
                                  ),
                                  DefaultCodeChunkIndicator(width: 20, controller: chunkController, notifier: notifier)
                                ],
                              );
                            },
                            findController: _findController,
                            findBuilder: (context, controller, readOnly) =>
                                CodeFindPanelView(controller: controller, readOnly: readOnly),
                            // toolbarController: const ContextMenuControllerImpl(),
                            sperator: Container(width: 1, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    // if (errorMessage.isNotEmpty)
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.elasticInOut,
                      alignment: Alignment(0, errorMessage.isEmpty ? 2 : 1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ErrorNotificationWidget(errorMessage: errorMessage),
                      ),
                    )
                  ],
                ),
              ),
              const VerticalDivider(
                width: 0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                      // color: Colors.grey[850],
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              jsonToView = prettyJson(_controller.text);
                              setState(() {
                                convertToYamlMode = false;
                              });
                            },
                            child: const Text('parse'),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _yamlViewer.text = convertJsonToYaml(_controller.text);
                              setState(() {
                                convertToYamlMode = true;
                              });
                            },
                            child: const Text('convert to yaml'),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: convertToYamlMode
                          ? CodeEditor(
                              style: CodeEditorStyle(
                                codeTheme: CodeHighlightTheme(
                                  languages: {
                                    'yaml': CodeHighlightThemeMode(mode: langJson),
                                  },
                                  theme: stackoverflowDarkTheme,
                                ),
                              ),
                              controller: _yamlViewer,
                              readOnly: true,
                              wordWrap: true,
                              indicatorBuilder: (context, editingController, chunkController, notifier) {
                                return Row(
                                  children: [
                                    DefaultCodeLineNumber(
                                      controller: editingController,
                                      notifier: notifier,
                                    ),
                                    DefaultCodeChunkIndicator(
                                        width: 20, controller: chunkController, notifier: notifier)
                                  ],
                                );
                              },
                              sperator: Container(width: 1, color: Colors.blue),
                            )
                          : ListView(
                              children: [
                                JsonViewerWidget(
                                  jsonDecode(jsonToView),
                                  false,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
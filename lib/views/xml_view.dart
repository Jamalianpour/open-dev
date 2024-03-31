import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_dev/utils/extensions.dart';
import 'package:open_dev/utils/json_utils.dart';
import 'package:open_dev/widgets/json/json_viewer_widget.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

import '../utils/theme.dart';
import '../widgets/json/json_find_widget.dart';

class XmlView extends StatefulWidget {
  const XmlView({super.key});

  @override
  State<XmlView> createState() => _XmlViewState();
}

class _XmlViewState extends State<XmlView> {
  final CodeLineEditingController _controller = CodeLineEditingController();
  final CodeLineEditingController _jsonViewer = CodeLineEditingController();
  String jsonToView = '{}';
  String errorMessage = '';
  late CodeFindController _findController;
  bool convertToJsonMode = false;

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
          child: Text('Xml parser', style: Theme.of(context).textTheme.headlineSmall),
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
                                    final document = XmlDocument.parse(_controller.text);
                                    _controller.text = document.toXmlString(pretty: true, indent: '    ');
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
                              // ElevatedButton(
                              //   onPressed: () {
                              //     try {
                              //       _controller.text = minifyJson(_controller.text);
                              //       errorMessage = '';
                              //     } catch (e) {
                              //       errorMessage = e.toString();
                              //     }
                              //   },
                              //   child: const Text('minify'),
                              // ),
                              // const SizedBox(width: 8),
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
                                  'xml': CodeHighlightThemeMode(mode: langJson),
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
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.errorContainer.lighten(),
                            ),
                          ),
                          height: 100,
                          width: double.maxFinite,
                          child: Text(
                            errorMessage,
                            style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                          ),
                        ),
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
                              Xml2Json xml2json = Xml2Json();
                              xml2json.parse(_controller.text);
                              String json = xml2json.toGData();

                              jsonToView = prettyJson(json);
                              setState(() {
                                convertToJsonMode = false;
                              });
                            },
                            child: const Text('parse'),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Xml2Json xml2json = Xml2Json();
                              xml2json.parse(_controller.text);
                              String json = xml2json.toGData();

                              jsonToView = prettyJson(json);

                              _jsonViewer.text = jsonToView;
                              setState(() {
                                convertToJsonMode = true;
                              });
                            },
                            child: const Text('convert to json'),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: convertToJsonMode
                          ? CodeEditor(
                              style: CodeEditorStyle(
                                codeTheme: CodeHighlightTheme(
                                  languages: {
                                    'json': CodeHighlightThemeMode(mode: langJson),
                                  },
                                  theme: stackoverflowDarkTheme,
                                ),
                              ),
                              controller: _jsonViewer,
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

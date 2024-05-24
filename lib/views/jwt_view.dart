import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_dev/utils/json_utils.dart';
import 'package:open_dev/utils/jwt_utils.dart';
import 'package:open_dev/widgets/secondary_button.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';

import '../utils/theme.dart';

class JwtView extends StatefulWidget {
  const JwtView({super.key});

  @override
  State<JwtView> createState() => _JwtViewState();
}

class _JwtViewState extends State<JwtView> {
  TextEditingController jwtBox = TextEditingController();
  CodeLineEditingController headerBox = CodeLineEditingController();
  CodeLineEditingController payloadBox = CodeLineEditingController();
  CodeLineEditingController signatureBox = CodeLineEditingController();

  bool headerError = false, payloadError = false, signatureError = false;

  JWTAlgorithm selectedAlgorithm = JWTAlgorithm.HS256;

  @override
  void initState() {
    jwtBox = TextEditingController(
        text:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.s3l8Taz5F9NdaqxLqAembjboOj_sLxMYoPp54VXsdLA');
    headerBox = CodeLineEditingController.fromText('''{
  "alg": "HS256",
  "typ": "JWT"
}''');
    payloadBox = CodeLineEditingController.fromText('''{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}''');
    signatureBox = CodeLineEditingController.fromText('here-is-your-secret');
    super.initState();
  }

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('JWT', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
        ],
      ),
    );
  }

  String generateJwt(String payload, String signature, String header) {
    try {
      jsonDecode(header);
      setState(() {
        headerError = false;
      });
    } catch (_) {
      setState(() {
        headerError = true;
      });
      return '';
    }
    try {
      jsonDecode(payload);
      setState(() {
        payloadError = false;
      });
    } catch (_) {
      setState(() {
        payloadError = true;
      });
      return '';
    }
    try {
      jwtBox.text = JwtUtils.encode(jsonDecode(payloadBox.text), signatureBox.text, selectedAlgorithm,
          header: jsonDecode(headerBox.text));
      setState(() {
        signatureError = false;
      });
    } catch (_) {}
    return '';
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
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: [
                SizedBox(
                    width: MediaQuery.sizeOf(context).width < 1200
                        ? MediaQuery.sizeOf(context).width * .5
                        : MediaQuery.sizeOf(context).width * .6,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('Algorithm'),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 85,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).splashColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: DropdownButtonFormField<JWTAlgorithm>(
                                    borderRadius: BorderRadius.circular(6),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                    items: <JWTAlgorithm>[JWTAlgorithm.HS256, JWTAlgorithm.HS384, JWTAlgorithm.HS512]
                                        .map((JWTAlgorithm value) {
                                      return DropdownMenuItem<JWTAlgorithm>(
                                        value: value,
                                        child: Text(value.name),
                                      );
                                    }).toList(),
                                    value: selectedAlgorithm,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAlgorithm = value ?? JWTAlgorithm.HS256;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            SecondaryButton(
                              text: 'Copy',
                              icon: const Icon(
                                CupertinoIcons.doc_on_clipboard_fill,
                                size: 14,
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Expanded(
                          child: TextField(
                            controller: jwtBox,
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), gapPadding: 0),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                            onChanged: (value) {
                              try {
                                // TODO: Fix first time paste token (at first time when headerbox and payload has been change token will generate automaticly)
                                var jwt = JwtUtils.decode(value);
                                var headerJson = prettyJson(jsonEncode(jwt.header));
                                var payloadJson = prettyJson(jsonEncode(jwt.payload));
                                headerBox.text = headerJson;
                                payloadBox.text = payloadJson;
                                if (JwtUtils.verify(value, signatureBox.text) != 1) {
                                  setState(() {
                                    signatureError = true;
                                  });
                                } else {
                                  setState(() {
                                    signatureError = false;
                                  });
                                }
                              } catch (_) {}
                            },
                            maxLines: 999,
                          ),
                        ),
                      ],
                    )),
                const VerticalDivider(),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Header:'),
                        const Spacer(),
                        SecondaryButton(
                          text: 'Copy',
                          icon: const Icon(
                            CupertinoIcons.doc_on_clipboard_fill,
                            size: 14,
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              headerError ? Theme.of(context).colorScheme.errorContainer : Theme.of(context).focusColor,
                        ),
                        child: CodeEditor(
                          style: CodeEditorStyle(
                            codeTheme: CodeHighlightTheme(
                              languages: {
                                'json': CodeHighlightThemeMode(mode: langJson),
                              },
                              theme: stackoverflowDarkTheme,
                            ),
                            fontSize: 14,
                          ),
                          controller: headerBox,
                          onChanged: (value) {
                            var jwt = generateJwt(payloadBox.text, signatureBox.text, headerBox.text);
                            if (jwt.isNotEmpty) {
                              jwtBox.text = jwt;
                            }
                          },
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Text('Payload:'),
                        const Spacer(),
                        SecondaryButton(
                          text: 'Copy',
                          icon: const Icon(
                            CupertinoIcons.doc_on_clipboard_fill,
                            size: 14,
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: payloadError
                              ? Theme.of(context).colorScheme.errorContainer
                              : Theme.of(context).focusColor,
                        ),
                        child: CodeEditor(
                          style: CodeEditorStyle(
                            codeTheme: CodeHighlightTheme(
                              languages: {
                                'json': CodeHighlightThemeMode(mode: langJson),
                              },
                              theme: stackoverflowDarkTheme,
                            ),
                            fontSize: 14,
                          ),
                          controller: payloadBox,
                          onChanged: (value) {
                            var jwt = generateJwt(payloadBox.text, signatureBox.text, headerBox.text);
                            if (jwt.isNotEmpty) {
                              jwtBox.text = jwt;
                            }
                          },
                        ),
                      ),
                    ),
                    const Divider(),
                    const Text('Signature'),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: signatureError
                              ? Theme.of(context).colorScheme.errorContainer
                              : Theme.of(context).focusColor,
                        ),
                        child: CodeEditor(
                          style: const CodeEditorStyle(
                            fontSize: 14,
                          ),
                          controller: signatureBox,
                          onChanged: (value) {
                            var jwt = generateJwt(payloadBox.text, signatureBox.text, headerBox.text);
                            if (jwt.isNotEmpty) {
                              jwtBox.text = jwt;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        )
      ],
    );
  }
}

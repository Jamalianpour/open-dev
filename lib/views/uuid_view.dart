import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/uuid_utils.dart';
import 'package:open_dev/widgets/data_widget.dart';

import '../widgets/secondary_button.dart';

class UuidView extends StatefulWidget {
  const UuidView({super.key});

  @override
  State<UuidView> createState() => _UuidViewState();
}

class _UuidViewState extends State<UuidView> {
  final TextEditingController _input = TextEditingController();
  final TextEditingController _generated = TextEditingController();
  final TextEditingController _generateCount = TextEditingController();

  String version = '', variant = '', timestamp = '', clockSeq = '', node = '';

  String uuidType = 'V1';

  @override
  void initState() {
    _input.text = UuidUtils.generateV1();
    var result = UuidUtils.decode(_input.text);
    version = result.$1.toString();
    variant = result.$2;
    timestamp = result.$3.toString();
    clockSeq = result.$4.toString();
    node = result.$5;
    super.initState();
  }

  void _decode() {
    var result = UuidUtils.decode(_input.text);
    version = result.$1.toString();
    variant = result.$2;
    timestamp = result.$3.toString();
    clockSeq = result.$4.toString();
    node = result.$5;
    setState(() {});
  }

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('UUID Generator/Decode', style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
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
              Expanded(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('input:'),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), gapPadding: 0),
                                isDense: true,
                                prefixIcon: const Icon(CupertinoIcons.underline),
                                contentPadding: const EdgeInsets.all(0),
                                filled: true,
                              ),
                              controller: _input,
                              onSubmitted: (value) {
                                _decode();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          SecondaryButton(
                            text: 'Decode',
                            height: 38,
                            onTap: () {
                              _decode();
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DataWidget(
                        value: version,
                        title: 'Version',
                        width: (MediaQuery.sizeOf(context).width - 250) * 0.41,
                        maxWidth: 700,
                        minWidth: 340,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DataWidget(
                        value: variant,
                        title: 'Variant',
                        width: (MediaQuery.sizeOf(context).width - 250) * 0.41,
                        maxWidth: 700,
                        minWidth: 340,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DataWidget(
                        value: timestamp,
                        title: 'Created',
                        width: (MediaQuery.sizeOf(context).width - 250) * 0.41,
                        maxWidth: 700,
                        minWidth: 340,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DataWidget(
                        value: clockSeq,
                        title: 'ClockSeq',
                        width: (MediaQuery.sizeOf(context).width - 250) * 0.41,
                        maxWidth: 700,
                        minWidth: 340,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DataWidget(
                        value: node,
                        title: 'Node',
                        width: (MediaQuery.sizeOf(context).width - 250) * 0.41,
                        maxWidth: 700,
                        minWidth: 340,
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('UUID:'),
                        const Spacer(),
                        SizedBox(
                          width: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).splashColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: DropdownButtonFormField<String>(
                                borderRadius: BorderRadius.circular(6),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                items: <String>['V1', 'V4', 'V5', 'V6', 'V7', 'V8'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: uuidType,
                                onChanged: (value) {
                                  setState(() {
                                    uuidType = value ?? 'V1';
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Text('×'),
                        const SizedBox(
                          width: 4,
                        ),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            controller: _generateCount,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4), gapPadding: 0, borderSide: BorderSide.none),
                              isCollapsed: true,
                              contentPadding: const EdgeInsets.all(5),
                              fillColor: Theme.of(context).splashColor,
                              filled: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SecondaryButton(
                          text: 'Generate',
                          onTap: () {
                            _generated.clear();
                            int count = int.parse(_generateCount.text);
                            for (int i = 0; i < count; i++) {
                              if (uuidType == 'V1') _generated.text = '${_generated.text}${UuidUtils.generateV1()}\n';
                              if (uuidType == 'V4') _generated.text = '${_generated.text}${UuidUtils.generateV4()}\n';
                              if (uuidType == 'V5') {
                                _generated.text =
                                    '${_generated.text}${UuidUtils.generateV5("00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000000")}\n';
                              }
                              if (uuidType == 'V6') _generated.text = '${_generated.text}${UuidUtils.generateV6()}\n';
                              if (uuidType == 'V7') _generated.text = '${_generated.text}${UuidUtils.generateV7()}\n';
                              if (uuidType == 'V8') _generated.text = '${_generated.text}${UuidUtils.generateV8()}\n';
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _generated,
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), gapPadding: 0),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        onChanged: (value) {},
                        maxLines: 999,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ))
      ],
    );
  }
}

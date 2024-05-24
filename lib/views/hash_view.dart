import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/hash_utils.dart';
import 'package:open_dev/widgets/data_widget.dart';

import '../widgets/secondary_button.dart';

class HashView extends StatefulWidget {
  const HashView({super.key});

  @override
  State<HashView> createState() => _HashViewState();
}

class _HashViewState extends State<HashView> {
  final TextEditingController _input = TextEditingController();
  final TextEditingController _secret = TextEditingController();
  HashUtils? hashUtils;
  bool hmac = false;
  String md5 = '', sha1 = '', sha224 = '', sha256 = '', sha384 = '', sha512 = '';

  void _generateHash(String text, {String? secret}) {
    if (hmac) {
      hashUtils = HashUtils(text, secret: secret);
      Future.wait([
        hashUtils!.md5HmacConvertor(),
        hashUtils!.sha1HmacConvertor(),
        hashUtils!.sha224HmacConvertor(),
        hashUtils!.sha256HmacConvertor(),
        hashUtils!.sha384HmacConvertor(),
        hashUtils!.sha512HmacConvertor(),
      ]).then(
        (value) {
          setState(() {
            md5 = value[0];
            sha1 = value[1];
            sha224 = value[2];
            sha256 = value[3];
            sha384 = value[4];
            sha512 = value[5];
          });
        },
      );
    } else {
      hashUtils = HashUtils(text);
      Future.wait([
        hashUtils!.md5Convertor(),
        hashUtils!.sha1Convertor(),
        hashUtils!.sha224Convertor(),
        hashUtils!.sha256Convertor(),
        hashUtils!.sha384Convertor(),
        hashUtils!.sha512Convertor(),
      ]).then(
        (value) {
          setState(() {
            md5 = value[0];
            sha1 = value[1];
            sha224 = value[2];
            sha256 = value[3];
            sha384 = value[4];
            sha512 = value[5];
          });
        },
      );
    }
  }

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('Hash Generator', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
          const Text('HMAC'),
          SizedBox(
            height: 30,
            width: 30,
            child: Checkbox.adaptive(
              value: hmac,
              onChanged: (value) {
                if (value == false) {
                  _secret.clear();
                }
                setState(() {
                  hmac = value ?? false;
                });
              },
            ),
          )
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('input:'),
                        const Spacer(),
                        SecondaryButton(
                          text: 'Clipboard',
                          onTap: () async {
                            ClipboardData? data = await Clipboard.getData('text/plain');
                            if (data != null) {
                              _input.text = data.text ?? '';
                              _generateHash(_input.text, secret: _secret.text);
                            }
                          },
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        SecondaryButton(
                          text: 'Sample',
                          onTap: () {
                            setState(() {
                              _input.text = 'This is a sample text to hash generator';
                              _generateHash(_input.text, secret: _secret.text);
                            });
                          },
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        SecondaryButton(
                          text: 'Clear',
                          onTap: () {
                            setState(() {
                              md5 = 'Non';
                              sha1 = 'Non';
                              sha224 = 'Non';
                              sha256 = 'Non';
                              sha384 = 'Non';
                              sha512 = 'Non';
                              _input.clear();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _input,
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), gapPadding: 0),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        onChanged: (value) {
                          _generateHash(value, secret: _secret.text);
                        },
                        maxLines: 999,
                      ),
                    ),
                    if (hmac) ...[
                      const SizedBox(
                        height: 8,
                      ),
                      const Text('secret:'),
                      TextField(
                        controller: _secret,
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), gapPadding: 0),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        onChanged: (value) {
                          _generateHash(_input.text, secret: value);
                        },
                        maxLines: 4,
                      )
                    ]
                  ],
                ),
              ),
              const VerticalDivider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('input size: ${_input.text.length} bytes'),
                    const SizedBox(
                      height: 8,
                    ),
                    DataWidget(
                      value: md5,
                      title: 'MD5',
                      width: MediaQuery.sizeOf(context).width * 0.29,
                      maxWidth: 460,
                      minWidth: 360,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DataWidget(
                      value: sha1,
                      title: 'SHA1',
                      width: MediaQuery.sizeOf(context).width * 0.29,
                      maxWidth: 460,
                      minWidth: 360,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DataWidget(
                      value: sha224,
                      title: 'SHA224',
                      width: MediaQuery.sizeOf(context).width * 0.29,
                      maxWidth: 460,
                      minWidth: 360,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DataWidget(
                      value: sha256,
                      title: 'SHA256',
                      width: MediaQuery.sizeOf(context).width * 0.29,
                      maxWidth: 460,
                      minWidth: 360,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DataWidget(
                      value: sha384,
                      title: 'SHA384',
                      width: MediaQuery.sizeOf(context).width * 0.29,
                      maxWidth: 460,
                      minWidth: 360,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DataWidget(
                      value: sha512,
                      title: 'SHA512',
                      width: MediaQuery.sizeOf(context).width * 0.29,
                      maxWidth: 460,
                      minWidth: 360,
                    ),
                  ],
                ),
              )
            ],
          ),
        ))
      ],
    );
  }
}

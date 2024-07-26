import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/password_utils.dart';
import 'package:open_dev/widgets/data_widget.dart';
import 'package:open_dev/widgets/secondary_button.dart';

class PasswordView extends StatefulWidget {
  const PasswordView({super.key});

  @override
  State<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  late final TextEditingController _passwordLength;
  final PasswordUtils _passwordUtils = PasswordUtils();
  
  bool includeUppercase = true;
  bool includeLowercase = true;
  bool includeNumbers = true;
  bool includeSpecialCharacters = true;
  
  String generatedCustomPassword = '';
  String shortPassword = '';
  String longPassword = '';
  String memorablePassword = '';
  String longMemorablePassword = '';
  String charactersOnly = '';
  String charactersAndNumbers = '';
  String charactersAndSpecialCharacters = '';
  String passphrase = '';

  @override
  void initState() {
    _passwordLength = TextEditingController(text: '12');
    shortPassword = _passwordUtils.generatePassword(length: 8);
    longPassword = _passwordUtils.generatePassword(length: 16);
    charactersOnly =
        _passwordUtils.generatePassword(length: 12, includeNumbers: false, includeSpecialCharacters: false);
    charactersAndNumbers =
        _passwordUtils.generatePassword(length: 12, includeNumbers: true, includeSpecialCharacters: false);
    charactersAndSpecialCharacters =
        _passwordUtils.generatePassword(length: 12, includeNumbers: false, includeSpecialCharacters: true);
    memorablePassword = _passwordUtils.generateMemorablePassword(numberOfWords: 2, includeSpecialCharacters: false);
    longMemorablePassword = _passwordUtils.generateMemorablePassword(numberOfWords: 4, includeSpecialCharacters: true);
    passphrase = _passwordUtils.generatePassphrase();
    generatedCustomPassword = _passwordUtils.generatePassword(
      length: int.parse(_passwordLength.text),
      includeLowercase: includeLowercase,
      includeUppercase: includeUppercase,
      includeNumbers: includeNumbers,
      includeSpecialCharacters: includeSpecialCharacters,
    );
    super.initState();
  }

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('Password Generator', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
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
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).focusColor,
            border: Border.all(color: Theme.of(context).focusColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _passwordLength,
                    decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: '12',
                        isDense: true,
                        label: Text('Password Length'),
                        labelStyle: TextStyle(fontSize: 13)),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text('Uppercase'),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Checkbox.adaptive(
                    value: includeUppercase,
                    onChanged: (value) {
                      setState(() {
                        includeUppercase = value ?? false;
                      });
                    },
                  ),
                ),
                const Text('Lowercase'),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Checkbox.adaptive(
                    value: includeLowercase,
                    onChanged: (value) {
                      setState(() {
                        includeLowercase = value ?? false;
                      });
                    },
                  ),
                ),
                const Text('Numbers'),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Checkbox.adaptive(
                    value: includeNumbers,
                    onChanged: (value) {
                      setState(() {
                        includeNumbers = value ?? false;
                      });
                    },
                  ),
                ),
                const Text('Symbols'),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Checkbox.adaptive(
                    value: includeSpecialCharacters,
                    onChanged: (value) {
                      setState(() {
                        includeSpecialCharacters = value ?? false;
                      });
                    },
                  ),
                ),
                const Spacer(),
                SecondaryButton(
                  text: 'Generate',
                  onTap: () {
                    generatedCustomPassword = _passwordUtils.generatePassword(
                      length: int.parse(_passwordLength.text),
                      includeLowercase: includeLowercase,
                      includeUppercase: includeUppercase,
                      includeNumbers: includeNumbers,
                      includeSpecialCharacters: includeSpecialCharacters,
                    );
                    setState(() {});
                  },
                  icon: Icon(
                    CupertinoIcons.gear,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: DataWidget(
              value: generatedCustomPassword,
              width: 400,
              maxWidth: 400,
              minWidth: 400,
              textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Random Password', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                onPressed: () {
                  shortPassword = _passwordUtils.generatePassword(length: 8);
                  longPassword = _passwordUtils.generatePassword(length: 16);
                  charactersOnly = _passwordUtils.generatePassword(
                      length: 12, includeNumbers: false, includeSpecialCharacters: false);
                  charactersAndNumbers = _passwordUtils.generatePassword(
                      length: 12, includeNumbers: true, includeSpecialCharacters: false);
                  charactersAndSpecialCharacters = _passwordUtils.generatePassword(
                      length: 12, includeNumbers: false, includeSpecialCharacters: true);
                  memorablePassword =
                      _passwordUtils.generateMemorablePassword(numberOfWords: 2, includeSpecialCharacters: false);
                  longMemorablePassword =
                      _passwordUtils.generateMemorablePassword(numberOfWords: 4, includeSpecialCharacters: true);
                  passphrase = _passwordUtils.generatePassphrase();
                  setState(() {});
                },
                icon: Icon(
                  CupertinoIcons.arrow_2_circlepath,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              DataWidget(
                value: shortPassword,
                title: '8 characters',
              ),
              DataWidget(
                value: longPassword,
                title: '16 characters',
              ),
              DataWidget(
                value: charactersOnly,
                title: 'Character only',
              ),
              DataWidget(
                value: charactersAndNumbers,
                title: 'Characters & numbers',
              ),
              DataWidget(
                value: charactersAndSpecialCharacters,
                title: 'Characters & symbols',
              ),
              DataWidget(
                value: memorablePassword,
                title: 'Memorable password',
              ),
              DataWidget(
                value: longMemorablePassword,
                title: 'Long memorable password',
              ),
              DataWidget(
                value: passphrase,
                title: 'Passphrase',
              ),
            ],
          ),
        )
      ],
    );
  }
}

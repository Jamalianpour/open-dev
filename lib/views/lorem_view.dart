import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/lorem_utils.dart';
import 'package:open_dev/widgets/secondary_button.dart';

class LoremView extends StatefulWidget {
  const LoremView({super.key});

  @override
  State<LoremView> createState() => _LoremViewState();
}

class _LoremViewState extends State<LoremView> {
  late final TextEditingController _paragraphCount;
  late final TextEditingController _minSentenceCount;
  late final TextEditingController _maxSentenceCount;
  late final TextEditingController _wordCount;
  bool startWithLorem = true;
  final LoremUtils _loremUtils = LoremUtils();
  String text = '';

  @override
  void initState() {
    text = _loremUtils.generateLoremIpsum(3, 3, 5, 10, 30, startWithLorem: startWithLorem);
    _paragraphCount = TextEditingController(text: '3');
    _minSentenceCount = TextEditingController(text: '3');
    _maxSentenceCount = TextEditingController(text: '5');
    _wordCount = TextEditingController(text: '15');
    super.initState();
  }

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('Lorem ipsum Generator', style: Theme.of(context).textTheme.headlineSmall),
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
                  width: 130,
                  child: TextField(
                    controller: _paragraphCount,
                    decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: '3',
                        isDense: true,
                        label: Text('Paragraphs'),
                        labelStyle: TextStyle(fontSize: 13)),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _minSentenceCount,
                    decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: '3',
                        isDense: true,
                        label: Text('Min Sentences'),
                        labelStyle: TextStyle(fontSize: 13)),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _maxSentenceCount,
                    decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: '5',
                        isDense: true,
                        label: Text('Max Sentences'),
                        labelStyle: TextStyle(fontSize: 13)),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _wordCount,
                    decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: '5',
                        isDense: true,
                        label: Text('Word per Sentences'),
                        labelStyle: TextStyle(fontSize: 13)),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                const Text('Start with Lorem'),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Checkbox.adaptive(
                    value: startWithLorem,
                    onChanged: (value) {
                      setState(() {
                        startWithLorem = value ?? false;
                      });
                    },
                  ),
                ),
                const Spacer(),
                SecondaryButton(
                  text: 'Generate',
                  onTap: () {
                    text = _loremUtils.generateLoremIpsum(
                        int.parse(_paragraphCount.text),
                        int.parse(_minSentenceCount.text),
                        int.parse(_maxSentenceCount.text),
                        int.parse(_wordCount.text),
                        int.parse(_wordCount.text),
                        startWithLorem: startWithLorem);
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Lorem Ipsum:',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).focusColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

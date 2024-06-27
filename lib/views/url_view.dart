import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_dev/utils/url_utils.dart';

class UrlView extends StatefulWidget {
  const UrlView({super.key});

  @override
  State<UrlView> createState() => _UrlViewState();
}

class _UrlViewState extends State<UrlView> {
  final UrlUtils _urlUtils = UrlUtils();

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  bool isEncode = true;

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('Url Encode/Decode', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
        ],
      ),
    );
  }

  Container _buildFunctionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              if (isEncode) {
                targetController.text = _urlUtils.urlEncode(sourceController.text);
              } else {
                targetController.text = _urlUtils.urlDecode(sourceController.text);
              }
              setState(() {});
            },
            child: Text(isEncode ? 'Encode' : 'Decode'),
          ),
          const SizedBox(width: 8),
          const Spacer(),
          ToggleButtons(
            isSelected: [isEncode, !isEncode],
            onPressed: (index) {
              isEncode = !isEncode;
              setState(() {});
            },
            borderRadius: BorderRadius.circular(6),
            constraints: const BoxConstraints(minHeight: 25, minWidth: 70),
            children: const [
              Text('Encode'),
              Text('Decode'),
            ],
          ),
        ],
      ),
    );
  }

  IconButton _buildSwapButton() {
    return IconButton(
      onPressed: () {
        String temp = sourceController.text;
        sourceController.text = targetController.text;
        targetController.text = temp;

        setState(() {});
      },
      icon: const Icon(CupertinoIcons.arrow_up_arrow_down),
      iconSize: 20,
      constraints: const BoxConstraints.tightFor(),
    );
  }

  Padding _buildTargetBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: TextField(
        controller: targetController,
        readOnly: true,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), filled: true, isDense: true, contentPadding: EdgeInsets.all(8)),
        maxLines: 100,
      ),
    );
  }

  Padding _buildSourceBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: TextField(
        controller: sourceController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), filled: true, isDense: true, contentPadding: EdgeInsets.all(8)),
        maxLines: 100,
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
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildFunctionBar(),
                    Expanded(
                      child: _buildSourceBox(),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                      child: Row(
                        children: [
                          _buildSwapButton(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildTargetBox(),
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

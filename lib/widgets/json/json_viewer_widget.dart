import 'package:flutter/material.dart';

/// Theme-aware syntax palette for the JSON viewer. Keys, numbers, and strings
/// pick contrasty colors for the current `Brightness`.
class _JsonPalette {
  _JsonPalette({
    required this.key,
    required this.number,
    required this.string,
    required this.boolean,
    required this.double,
    required this.punctuation,
    required this.expandIcon,
  });

  final Color key;
  final Color number;
  final Color string;
  final Color boolean;
  final Color double;
  final Color punctuation;
  final Color expandIcon;

  factory _JsonPalette.of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (dark) {
      return _JsonPalette(
        key: const Color(0xff88aece),
        number: const Color(0xfff08d49),
        string: const Color(0xffb5bd68),
        boolean: Colors.orange.shade300,
        double: Colors.teal.shade200,
        punctuation: Colors.grey,
        expandIcon: Colors.grey.shade400,
      );
    }
    return _JsonPalette(
      key: const Color(0xff0451a5),
      number: const Color(0xff098658),
      string: const Color(0xffa31515),
      boolean: Colors.orange.shade800,
      double: Colors.teal.shade700,
      punctuation: Colors.grey.shade700,
      expandIcon: Colors.grey.shade700,
    );
  }
}

class JsonViewerWidget extends StatefulWidget {
  final Map<String, dynamic> jsonObj;
  final bool? notRoot;
  final bool expandAll;

  const JsonViewerWidget(this.jsonObj, this.expandAll, {super.key, this.notRoot});

  @override
  JsonViewerWidgetState createState() => JsonViewerWidgetState();
}

class JsonViewerWidgetState extends State<JsonViewerWidget> {
  final openFlag = <String, bool>{};
  bool? expandAll;

  @override
  void didUpdateWidget(JsonViewerWidget oldWidget) {
    if (oldWidget.expandAll != widget.expandAll) {
      setState(() {
        openFlag.clear();
        expandAll = widget.expandAll;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    expandAll ??= widget.expandAll;
    final palette = _JsonPalette.of(context);
    return Padding(
      padding: EdgeInsets.only(left: widget.notRoot ?? false ? 14.0 : 0.0),
      child: ListView.builder(
        itemCount: widget.jsonObj.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _getItem(widget.jsonObj.entries.toList()[index], palette);
        },
      ),
    );
  }

  Column _getItem(dynamic content, _JsonPalette palette) {
    final ink = isInkWell(content.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: ink
              ? () {
                  setState(() {
                    openFlag[content.key] = !(openFlag[content.key] ?? expandAll!);
                    expandAll = false;
                  });
                }
              : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ink)
                InkWell(
                  onTap: () {
                    setState(() {
                      openFlag[content.key] = !(openFlag[content.key] ?? expandAll!);
                      expandAll = false;
                    });
                  },
                  child: Icon((openFlag[content.key] ?? expandAll!) ? Icons.arrow_drop_down : Icons.arrow_right,
                      size: 14, color: palette.expandIcon),
                )
              else
                const SizedBox(
                  width: 14,
                ),
              Text(
                content.key,
                style: TextStyle(
                  color: palette.key,
                ),
              ),
              Text(
                ':',
                style: TextStyle(color: palette.punctuation),
              ),
              const SizedBox(width: 3),
              Flexible(
                child: getValueWidget(context, content.value),
              )
            ],
          ),
        ),
        const SizedBox(height: 4),
        if (ink && (openFlag[content.key] ?? expandAll!)) getContentWidget(content.value, expandAll!),
      ],
    );
  }
}

class JsonArrayViewerWidget extends StatefulWidget {
  final List<dynamic> jsonArray;

  final bool? notRoot;

  final bool expandAll;

  const JsonArrayViewerWidget(this.jsonArray, this.expandAll, {super.key, this.notRoot});

  @override
  // ignore: library_private_types_in_public_api
  _JsonArrayViewerWidgetState createState() => _JsonArrayViewerWidgetState();
}

class _JsonArrayViewerWidgetState extends State<JsonArrayViewerWidget> {
  List<bool?>? openFlag = [];
  bool? expandAll;

  @override
  void didUpdateWidget(JsonArrayViewerWidget oldWidget) {
    if (oldWidget.expandAll != widget.expandAll) {
      setState(() {
        openFlag = []..length = widget.jsonArray.length;
        expandAll = widget.expandAll;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    expandAll ??= widget.expandAll;
    final palette = _JsonPalette.of(context);
    if (widget.notRoot ?? false) {
      return Padding(
        padding: const EdgeInsets.only(left: 14.0),
        child: ListView.builder(
          itemCount: widget.jsonArray.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return _getItem(widget.jsonArray[index], index, palette);
          },
        ),
      );
    }
    return ListView.builder(
      itemCount: widget.jsonArray.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _getItem(widget.jsonArray[index], index, palette);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    openFlag = []..length = widget.jsonArray.length;
  }

  void Function() onTap(int index) => () => setState(() {
        openFlag![index] = !(openFlag![index] ?? expandAll!);
        expandAll = false;
      });

  Column _getItem(dynamic content, int index, _JsonPalette palette) {
    final ink = isInkWell(content);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: ink ? onTap(index) : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ink)
                Icon((openFlag![index] ?? expandAll!) ? Icons.arrow_drop_down : Icons.arrow_right,
                    size: 14, color: palette.expandIcon),
              Text(
                '$index',
                style: TextStyle(color: ink ? palette.key : palette.punctuation),
              ),
              Text(
                ':',
                style: TextStyle(color: palette.punctuation),
              ),
              const SizedBox(width: 3),
              Flexible(
                child: getValueWidget(context, content),
              )
            ],
          ),
        ),
        const SizedBox(height: 4),
        if (ink && (openFlag![index] ?? expandAll!)) getContentWidget(content, expandAll!)
      ],
    );
  }
}

Widget getValueWidget(BuildContext context, dynamic content) {
  final palette = _JsonPalette.of(context);
  if (content == null) {
    return Text(
      'null',
      style: TextStyle(color: palette.punctuation),
    );
  } else if (content is int) {
    return SelectableText(
      content.toString(),
      style: TextStyle(color: palette.number),
    );
  } else if (content is String) {
    return SelectableText(
      '"$content"',
      style: TextStyle(color: palette.string),
    );
  } else if (content is bool) {
    return Text(
      content.toString(),
      style: TextStyle(color: palette.boolean),
    );
  } else if (content is double) {
    return SelectableText(
      content.toString(),
      style: TextStyle(color: palette.double),
    );
  } else if (content is List) {
    return Text(
      '[${content.length}]',
      style: TextStyle(color: palette.punctuation),
    );
  }

  return Text(
    '{...}',
    style: TextStyle(color: palette.punctuation),
  );
}

bool isInkWell(dynamic content) => content != null && (content is List || content is Map) && content.isNotEmpty as bool;

StatefulWidget getContentWidget(dynamic content, bool expandAll) {
  if (content is List) {
    return JsonArrayViewerWidget(content, expandAll, notRoot: true);
  } else if (content is Map<String, dynamic>) {
    return JsonViewerWidget(content, expandAll, notRoot: true);
  }
  throw Exception('${content.runtimeType} is not valid');
}

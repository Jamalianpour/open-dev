import 'package:flutter/material.dart';

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
    return Padding(
      padding: EdgeInsets.only(left: widget.notRoot ?? false ? 14.0 : 0.0),
      child: ListView.builder(
        itemCount: widget.jsonObj.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _getItem(widget.jsonObj.entries.toList()[index]);
        },
      ),
    );
  }

  Column _getItem(dynamic content) {
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
                      size: 14, color: Colors.grey[700]),
                )
              else
                const SizedBox(
                  width: 14,
                ),
              Text(
                content.key,
                style: const TextStyle(
                  color: Color(0xff88aece),
                ),
              ),
              const Text(
                ':',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 3),
              Flexible(
                child: getValueWidget(content.value),
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
    if (widget.notRoot ?? false) {
      return Padding(
        padding: const EdgeInsets.only(left: 14.0),
        child: ListView.builder(
          itemCount: widget.jsonArray.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return _getItem(widget.jsonArray[index], index);
          },
        ),
      );
    }
    return ListView.builder(
      itemCount: widget.jsonArray.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _getItem(widget.jsonArray[index], index);
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

  Column _getItem(dynamic content, int index) {
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
                    size: 14, color: Colors.grey[700]),
              Text(
                '$index',
                style: TextStyle(color: ink ? const Color(0xff88aece) : Colors.grey),
              ),
              const Text(
                ':',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 3),
              Flexible(
                child: getValueWidget(content),
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

Widget getValueWidget(dynamic content) {
  if (content == null) {
    return const Text(
      'null',
      style: TextStyle(color: Colors.grey),
    );
  } else if (content is int) {
    return SelectableText(
      content.toString(),
      style: const TextStyle(color: Color(0xfff08d49)),
    );
  } else if (content is String) {
    return SelectableText(
      '"$content"',
      style: const TextStyle(color: Color(0xffb5bd68)),
    );
  } else if (content is bool) {
    return Text(
      content.toString(),
      style: TextStyle(color: Colors.orange[800]),
    );
  } else if (content is double) {
    return SelectableText(
      content.toString(),
      style: const TextStyle(color: Colors.teal),
    );
  } else if (content is List) {
    return Text(
      '[${content.length}]',
      style: const TextStyle(color: Colors.grey),
    );
  }

  return const Text(
    '{...}',
    style: TextStyle(color: Colors.grey),
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

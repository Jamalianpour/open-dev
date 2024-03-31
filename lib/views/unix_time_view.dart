import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/unix_utils.dart';

import '../widgets/data_widget.dart';

class UnixTimeView extends StatefulWidget {
  const UnixTimeView({super.key});

  @override
  State<UnixTimeView> createState() => _UnixTimeViewState();
}

class _UnixTimeViewState extends State<UnixTimeView> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  String describe = '';
  String executions = '';
  String errorMessage = '';
  int unixType = 1;
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    controller.text = dateTime.millisecondsSinceEpoch.toString();
    super.initState();
  }

  DateTime getDateTime() {
    switch (unixType) {
      case 0:
        return UnixUtils.getDateTimeFromUnixTimestamp(int.parse(controller.text));
      case 1:
        return UnixUtils.getDateTimeFromUnixTimestampMs(int.parse(controller.text));
      case 2:
        return UnixUtils.getDateTimeFromUnixTimestampMicros(int.parse(controller.text));
      default:
        return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Unix Time Converter', style: Theme.of(context).textTheme.headlineSmall),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 325,
                  child: TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: const Icon(CupertinoIcons.time),
                      contentPadding: const EdgeInsets.all(0),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            dateTime = getDateTime();
                          });
                        },
                        icon: const Icon(CupertinoIcons.arrow_2_squarepath),
                        tooltip: 'Convert',
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: controller,
                    onSubmitted: (value) {
                      setState(() {
                        dateTime = getDateTime();
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                const Text('Type: '),
                CupertinoSlidingSegmentedControl<int>(
                  groupValue: unixType,
                  children: const {
                    0: Text(
                      'second',
                      style: TextStyle(fontSize: 12),
                    ),
                    1: Text(
                      'millisecond',
                      style: TextStyle(fontSize: 12),
                    ),
                    2: Text(
                      'microsecond',
                      style: TextStyle(fontSize: 12),
                    ),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      unixType = value ?? 0;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        DataWidget(
                          title: 'Local:',
                          value: UnixUtils.toRFC2822(dateTime),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DataWidget(
                          title: 'ISO 8601:',
                          value: dateTime.toIso8601String(),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DataWidget(
                          title: 'Relative:',
                          value: UnixUtils.toRelativeTime(dateTime, DateTime.now()),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DataWidget(
                          title: 'Ordinal:',
                          value: UnixUtils.toOrdinalDate(dateTime),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DataWidget(
                          title: 'Unix time:',
                          value: UnixUtils.getUnixTimestamp(dateTime).toString(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DataWidget(
                          title: 'Day of Year:',
                          width: 80,
                          value: UnixUtils.toDayOfYear(dateTime).toString(),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DataWidget(
                          title: 'Week of Year:',
                          width: 80,
                          value: UnixUtils.toWeekOfYear(dateTime).toString(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DataWidget(
                          title: 'Other:',
                          value: UnixUtils.toDDMMYYYY(dateTime),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DataWidget(
                          value: UnixUtils.toEEEEdMMMMd(dateTime),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DataWidget(
                          value: UnixUtils.toYYMMDDHHMM(dateTime),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DataWidget(
                          value: UnixUtils.toRFC3339(dateTime),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DataWidget(
                          value: UnixUtils.toLongWeekdayMonth(dateTime),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DataWidget(
                          value: UnixUtils.toHmmss(dateTime),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

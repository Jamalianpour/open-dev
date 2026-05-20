import 'package:cron_expression_descriptor/cron_expression_descriptor.dart';
import 'package:cron_parser/cron_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/error_notification_widget.dart';

class CronView extends StatefulWidget {
  const CronView({super.key});

  @override
  State<CronView> createState() => _CronViewState();
}

class _CronViewState extends State<CronView> {
  final TextEditingController controller = TextEditingController();
  String describe = '';
  String executions = '';
  String errorMessage = '';
  int _runCount = 10;
  String _timezone = 'UTC';

  static const List<String> _timezones = [
    'UTC',
    'Asia/Tehran',
    'America/New_York',
    'America/Los_Angeles',
    'America/Chicago',
    'Europe/London',
    'Europe/Berlin',
    'Asia/Tokyo',
    'Asia/Shanghai',
    'Asia/Kolkata',
    'Australia/Sydney',
  ];

  void _parse() {
    try {
      describe = '';
      executions = '';
      CronExpressionDescriptor cronUtils = CronExpressionDescriptor();
      describe =
          cronUtils.convertCronToHumanReadable(cronExpression: controller.text);
      final cronIterator = Cron().parse(controller.text, _timezone);
      final buffer = StringBuffer();
      for (int i = 1; i <= _runCount; i++) {
        buffer.writeln('$i.  ${cronIterator.next()}');
      }
      executions = buffer.toString().trimRight();
      errorMessage = '';
      setState(() {});
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cron Job parser', style: Theme.of(context).textTheme.headlineSmall),
          const Divider(),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: SizedBox(
              width: 250,
              child: TextField(
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '* * * * *'),
                textAlign: TextAlign.center,
                controller: controller,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\*\-, \/]')),
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('Timezone: '),
                  DropdownButton<String>(
                    value: _timezone,
                    items: [
                      for (final tz in _timezones)
                        DropdownMenuItem(value: tz, child: Text(tz)),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _timezone = v);
                    },
                  ),
                ]),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('Show next: '),
                  DropdownButton<int>(
                    value: _runCount,
                    items: const [
                      DropdownMenuItem(value: 5, child: Text('5')),
                      DropdownMenuItem(value: 10, child: Text('10')),
                      DropdownMenuItem(value: 20, child: Text('20')),
                      DropdownMenuItem(value: 50, child: Text('50')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _runCount = v);
                    },
                  ),
                ]),
                FilledButton.icon(
                  onPressed: _parse,
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text('Parse'),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Describe:', style: TextStyle(fontSize: 15),),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Next executions:', style: TextStyle(height: 1.7),),
                  ],
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                        child: Text(
                          describe,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (executions.isNotEmpty)
                      Container(
                        constraints: const BoxConstraints(maxHeight: 280),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.outlineVariant),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 36, 8),
                              child: SingleChildScrollView(
                                child: SelectableText(
                                  executions,
                                  style: const TextStyle(
                                      fontFamily: 'monospace', fontSize: 13),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                iconSize: 16,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 28, minHeight: 28),
                                tooltip: 'Copy',
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: executions));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // if (errorMessage.isNotEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: errorMessage.isNotEmpty ? 1 : 0,
                child: ErrorNotificationWidget(
                  errorMessage: errorMessage,
                  width: null,
                  height: null,
                ),
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Icon(
                CupertinoIcons.info,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                width: 2,
              ),
              const Expanded(
                  child: Text('The cron expression is made of five fields. Each field can have the following values.')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('minute (0-59)'),
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('hour (0 - 23)'),
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('day of the month (1 - 31)'),
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('month (1 - 12)'),
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('day of the week (0 - 6)'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

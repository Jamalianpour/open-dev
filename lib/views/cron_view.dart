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
          Center(
            child: TextButton(
                onPressed: () {
                  try {
                    describe = '';
                    executions = '';
                    CronExpressionDescriptor cronUtils = CronExpressionDescriptor();
                    describe = cronUtils.convertCronToHumanReadable(cronExpression: controller.text);
                    var cronIterator = Cron().parse(controller.text, "Asia/Tehran");
                    executions += '${cronIterator.next()}\n';
                    executions += '${cronIterator.next()}\n';
                    executions += '${cronIterator.next()}\n';
                    executions += '${cronIterator.next()}\n';
                    executions += '${cronIterator.next()}';
                    errorMessage = '';
                    setState(() {});
                  } catch (e) {
                    setState(() {
                      errorMessage = e.toString();
                    });
                  }
                },
                child: const Text('Parse')),
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
                    const SizedBox(
                      height: 8,
                    ),
                    Text(executions, style: const TextStyle(height: 1.7),),
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

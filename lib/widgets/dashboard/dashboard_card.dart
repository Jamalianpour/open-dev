import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final Function onTap;
  const DashboardCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
      onTap: () => onTap(),
      child: Container(
        height: 102,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Theme.of(context).focusColor,
          border: Border.all(color: Theme.of(context).focusColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              icon,
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(description, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
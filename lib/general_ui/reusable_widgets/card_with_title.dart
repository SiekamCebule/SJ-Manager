import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CardWithTitle extends StatelessWidget {
  const CardWithTitle({
    super.key,
    required this.title,
    required this.child,
    this.color,
  });

  final Widget title;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            const Gap(5),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

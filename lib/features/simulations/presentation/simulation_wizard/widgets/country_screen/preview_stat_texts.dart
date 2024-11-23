import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PreviewStatTexts extends StatelessWidget {
  const PreviewStatTexts({
    super.key,
    required this.description,
    this.content,
    this.contentText,
  }) : assert((content != null) ^ (contentText != null));

  final String description;
  final Widget? content;
  final String? contentText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Gap(5),
        Text(
          description,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(5),
        if (content != null) content!,
        if (contentText != null)
          Expanded(
            child: Text(
              contentText!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
      ],
    );
  }
}

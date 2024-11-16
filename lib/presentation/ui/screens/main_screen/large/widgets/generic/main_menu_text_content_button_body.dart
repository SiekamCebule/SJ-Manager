import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sj_manager/presentation/ui/responsiveness/ui_constants.dart';

class MainMenuTextContentButtonBody extends StatelessWidget {
  const MainMenuTextContentButtonBody({
    super.key,
    required this.titleText,
    required this.contentText,
    this.decorationWidget,
  });

  final String titleText;
  final String contentText;
  final Widget? decorationWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: UiMainMenuConstants.horizontalSpaceBetweenButtonItems,
        top: UiMainMenuConstants.verticalSpaceBetweenButtonItems,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const Gap(UiMainMenuConstants.verticalSpaceBetweenButtonItems),
                Row(
                  children: [
                    //const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
                    Expanded(
                      flex: 7,
                      child: Text(
                        contentText,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                    const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
                    if (decorationWidget != null) ...[
                      Expanded(
                        flex: 4,
                        child: Align(
                          alignment: const Alignment(0, -0.2),
                          child: decorationWidget!,
                        ),
                      ),
                      const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

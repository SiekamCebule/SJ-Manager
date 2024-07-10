import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sj_manager/ui/responsiveness/ui_main_menu_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/effects/shaking_widget.dart';
import 'package:sj_manager/ui/screens/main_screen/widgets/app_title.dart';

class ShakingAppTitle extends StatefulWidget {
  const ShakingAppTitle({super.key});

  @override
  State<ShakingAppTitle> createState() => _ShakingAppTitleState();
}

class _ShakingAppTitleState extends State<ShakingAppTitle> {
  late final StreamSubscription<void> _shakeTicksSubscription;
  final _shakingWidgetKey = GlobalKey<ShakingWidgetState>();

  @override
  void initState() {
    final shakeTicks = Stream<void>.periodic(UiMainMenuConstants.appTitleShakeInterval);
    _shakeTicksSubscription = shakeTicks.listen((_) {
      _shakingWidgetKey.currentState?.shake();
    });
    super.initState();
  }

  @override
  void dispose() {
    _shakeTicksSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShakingWidget(
      key: _shakingWidgetKey,
      shakeDuration: UiMainMenuConstants.appTitleShakeDuration,
      curve: Curves.linear,
      child: const AppTitle(),
    );
  }
}

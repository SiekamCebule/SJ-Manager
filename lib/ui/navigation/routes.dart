import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';
import 'package:sj_manager/ui/screens/database_editor/database_editor_screen.dart';
import 'package:sj_manager/ui/screens/main_screen/main_screen.dart';
import 'package:sj_manager/ui/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';

void configureRoutes(FluroRouter router) {
  void define(
    String routePath,
    Widget? Function(BuildContext?, Map<String, List<String>>) handlerFunc, {
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transitionBuilder,
    TransitionType? transitionType,
    Curve? inCurve,
    Curve? outCurve,
  }) {
    router.define(
      routePath,
      handler: Handler(handlerFunc: handlerFunc),
      transitionDuration: Durations.long3,
      transitionType: transitionBuilder != null ? TransitionType.custom : transitionType,
      transitionBuilder: transitionBuilder ??
          (context, animation, secondaryAnimation, child) {
            final slideIn =
                CurvedAnimation(parent: animation, curve: inCurve ?? Curves.easeInOutSine)
                    .drive(
              Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ),
            );
            final slideOut = CurvedAnimation(
                    parent: secondaryAnimation, curve: outCurve ?? Curves.easeOutBack)
                .drive(
              Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0, 1),
              ),
            );
            return SlideTransition(
              position: slideOut,
              child: SlideTransition(
                position: slideIn,
                child: child,
              ),
            );
          },
    );
  }

  Widget defaultInFromLeft(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final slideIn = CurvedAnimation(parent: animation, curve: Curves.easeInOutSine).drive(
      Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero),
    );
    final slideOut =
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOutBack).drive(
      Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1)),
    );
    return SlideTransition(
      position: slideOut,
      child: SlideTransition(position: slideIn, child: child),
    );
  }

  Widget defaultMaterialFullscreen(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final scaleIn = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic).drive(
      Tween<double>(begin: 0.9, end: 1.0),
    );

    final fadeIn = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic).drive(
      Tween<double>(begin: 0.0, end: 1.0),
    );

    final scaleOut =
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic).drive(
      Tween<double>(begin: 1.0, end: 1.1),
    );

    return FadeTransition(
      opacity: fadeIn,
      child: ScaleTransition(
        scale: animation.status == AnimationStatus.reverse ? scaleOut : scaleIn,
        child: child,
      ),
    );
  }

  define(
    '/',
    (context, params) => const MainScreen(),
  );
  define(
    '/settings',
    (context, params) => const SettingsScreen(),
    transitionBuilder: defaultInFromLeft,
  );
  define(
    '/databaseEditor/:gameVariantId',
    (context, params) {
      final gameVariantId = params['gameVariantId']![0];
      final gameVariant = context!
          .read<ItemsRepo<GameVariant>>()
          .last
          .singleWhere((variant) => variant.id == gameVariantId);
      return MultiProvider(
        providers: [
          Provider.value(value: gameVariant),
        ],
        child: const DatabaseEditorScreen(),
      );
    },
    transitionBuilder: defaultInFromLeft,
  );
}

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/ui/screens/database_editor/database_editor_screen.dart';
import 'package:sj_manager/ui/screens/main_screen/main_screen.dart';
import 'package:sj_manager/ui/screens/settings/settings_screen.dart';

void configureRoutes(FluroRouter router) {
  void define(String routePath,
      Widget? Function(BuildContext?, Map<String, List<String>>) handlerFunc) {
    router.define(
      routePath,
      handler: Handler(handlerFunc: handlerFunc),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final slideIn = CurvedAnimation(parent: animation, curve: Curves.easeIn).drive(
          Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ),
        );
        final slideOut =
            CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOut).drive(
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

  define('/', (context, params) => const MainScreen());
  define('/settings', (context, params) => const SettingsScreen());
  define('/databaseEditor', (context, params) => const DatabaseEditorScreen());
}

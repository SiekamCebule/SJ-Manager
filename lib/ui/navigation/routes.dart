import 'package:fluro/fluro.dart';
import 'package:sj_manager/ui/screens/main_screen/main_screen.dart';
import 'package:sj_manager/ui/screens/settings/settings_screen.dart';

void configureRoutes(FluroRouter router) {
  router.define(
    '/',
    handler: Handler(
      handlerFunc: (context, params) => const MainScreen(),
    ),
  );
  router.define(
    '/settings',
    handler: Handler(
      handlerFunc: (context, params) => const SettingsScreen(),
    ),
    transitionType: TransitionType.inFromLeft,
  );
}

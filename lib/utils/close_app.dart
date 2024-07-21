import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:sj_manager/utils/platform.dart';

Future<void> closeApp() async {
  if (Platform.isAndroid) {
    await SystemNavigator.pop();
  } else if (Platform.isIOS) {
    exit(0);
  } else if (platformIsDesktop) {
    await FlutterWindowClose.closeWindow();
  } else if (kIsWeb) {
    debugPrint('Cannot close app on web');
  } else {
    throw StateError('Unknown platform');
  }
}

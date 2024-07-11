import 'dart:io';

bool get platformIsDesktop {
  return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}

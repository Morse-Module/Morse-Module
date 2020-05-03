// 🎯 Dart imports:
import 'dart:io';

// 🌎 Project imports:
import 'package:morse_module/statuses.dart';

enum OperatingSystem { macos, linux, windows }

OperatingSystem currentOS() {
  if (Platform.isLinux) return OperatingSystem.linux;
  if (Platform.isWindows) return OperatingSystem.windows;
  if (Platform.isMacOS) {
    return OperatingSystem.macos;
  }
  error('Platform ${Platform.operatingSystem} not supported');
}

String homePath() {
  final envVars = Platform.environment;
  if (Platform.isLinux || Platform.isMacOS) {
    return envVars['HOME'];
  }
  return envVars['HOMEPATH'];
}

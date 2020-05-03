// 🎯 Dart imports:
import 'dart:io';

// 🌎 Project imports:
import 'package:soc/statuses.dart';

enum OperatingSystem { macos, linux, windows }

OperatingSystem currentOS() {
  if (Platform.isLinux) return OperatingSystem.linux;
  if (Platform.isWindows) return OperatingSystem.windows;
  if (Platform.isMacOS) {
    return OperatingSystem.macos;
  }
  error('Platform ${Platform.operatingSystem} not supported');
}

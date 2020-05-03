// 🎯 Dart imports:
import 'dart:io';

// 🌎 Project imports:
import 'package:soc/applications/application.dart';
import 'package:soc/applications/vscode.dart';

class ApplicationFactory {
  Application getApplication(String applicationName) {
    switch (applicationName) {
      case 'vscode':
        return VsCode();
      default:
        print('The application ${applicationName} is not supported');
        exitCode = 2;
        return null;
    }
  }
}

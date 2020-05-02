import 'package:soc/applications/application.dart';
import 'package:soc/applications/vscode.dart';

import 'dart:io';

class ApplicationFactory {

    Application getApplication(String applicationName) {
      switch (applicationName) {
        case VsCode.name:
          return VsCode();
        default:
          print('The application ${applicationName} is not supported');
          exitCode = 2;
          return null;
      }
    }

  }
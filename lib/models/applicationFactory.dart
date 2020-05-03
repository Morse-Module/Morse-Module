// 🌎 Project imports:
import 'package:morse_module/applications/vscode.dart';
import 'package:morse_module/models/application.dart';

class ApplicationFactory {
  static Application getApplication(String applicationName) {
    switch (applicationName) {
      case 'vscode':
        return VsCode();
    }
  }
}

// 🌎 Project imports:
import 'package:morse_module/applications/vscode.dart';
import 'package:morse_module/models/application.dart';
import 'package:morse_module/statuses.dart';

class ApplicationFactory {
  static Application getApplication(String applicationName) {
    switch (applicationName) {
      case 'vscode':
        return VsCode();
      default:
        error('Please define an application');
    }
  }
}

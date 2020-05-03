// 🌎 Project imports:
import 'package:soc/applications/vscode.dart';
import 'package:soc/models/application.dart';

class ApplicationFactory {
  static Application getApplication(String applicationName) {
    switch (applicationName) {
      case 'vscode':
        return VsCode();
    }
  }
}

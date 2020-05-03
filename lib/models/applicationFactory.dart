// 🌎 Project imports:
import 'package:soc/applications/vscode.dart';

class ApplicationFactory {
  static void getApplication(String applicationName) {
    switch (applicationName) {
      case VsCode.name:
        VsCode();
    }
  }
}

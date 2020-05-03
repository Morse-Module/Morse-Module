// 🌎 Project imports:
import 'package:morse_module/applications/vscode.dart';

class ApplicationFactory {
  static void getApplication(String applicationName) {
    switch (applicationName) {
      case VsCode.name:
        VsCode();
    }
  }
}

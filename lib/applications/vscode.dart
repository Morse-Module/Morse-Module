// 🌎 Project imports:
import 'package:morse_module/models/application.dart';

class VsCode extends Application {
  @override
  final name = 'vscode';

  @override
  final Map<String, String> commandDependents = {
    'code': 'https://code.visualstudio.com/docs/setup/setup-overview'
  };
}

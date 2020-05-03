// 📦 Package imports:
import 'package:process_run/process_run.dart';

// 🌎 Project imports:
import 'package:soc/models/application.dart';

class VsCode extends Application {
  @override
  static const name = 'vscode';

  @override
  final Map<String, String> commandDependents = {
    'code': 'https://code.visualstudio.com/docs/setup/setup-overview'
  };

  @override
  
}

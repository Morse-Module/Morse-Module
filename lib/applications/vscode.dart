// 📦 Package imports:
import 'package:process_run/process_run.dart';

// 🌎 Project imports:
import 'package:soc/models/application.dart';
import 'package:soc/platforms.dart';

class VsCode extends Application {
  @override
  final Map<String, String> commandDependents = {
    'code': 'https://code.visualstudio.com/docs/setup/setup-overview'
  };

  @override
  final String listExtensions = 'code --list-extensions';

  @override
  final Map<OperatingSystem, String> filePath = {
    OperatingSystem.macos:
        '${homePath()}/Library/Application Support/Code/User/settings.json',
    OperatingSystem.linux: '${homePath()}/.config/Code/User/settings.json',
    OperatingSystem.windows:
        '${getEnvVar('APPDATA')}\\Code\\User\\settings.json',
  };
}

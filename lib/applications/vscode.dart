// 📦 Package imports:
import 'dart:io';

import 'package:process_run/process_run.dart';

// 🌎 Project imports:
import 'package:soc/applications/application.dart';

class VsCode with Application {
  @override
  final name = 'vscode';
  @override
  final settingsFileName = 'settings.json';
  @override
  final configFilePaths = <ConfigType, Map<String, String>>{
    ConfigType.settings: {
      'windows': '%APPDATA%\\Code\\User\\settings.json',
      'macos':
          '${Platform.environment['HOME']}/Library/Application Support/Code/User/settings.json',
      'linux':
          '${Platform.environment['HOME']}/.config/Code/User/settings.json',
    },
    ConfigType.extensions: {
      'windows': '%USERPROFILE%\\.vscode\\extensions',
      'macos': '${Platform.environment['HOME']}/.vscode/extensions',
      'linux': '${Platform.environment['HOME']}/.vscode/extensions',
    },
  };

  @override
  void installExtension(String extensionName) async =>
      await run('code', ['--install-extension ${extensionName}']);

  @override
  void uninstallExtension(String extensionName) async =>
      await run('code', ['--uninstall-extensions ${extensionName}']);
}

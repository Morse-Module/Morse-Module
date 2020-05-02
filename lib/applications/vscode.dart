import 'package:process_run/process_run.dart';
import 'package:soc/applications/application.dart';

class VsCode extends Application {
  @override
  static const name = 'vscode';
  @override
  final configFilePaths = <ConfigType, Map<String, String>>{
    ConfigType.settings: {
      'windows': '%APPDATA%\\Code\\User\\settings.json',
      'macos': '\$HOME/Library/Application Support/Code/User/settings.json',
      'linux': '\$HOME/.config/Code/User/settings.json',
    },
    ConfigType.extensions: {
      'windows': '%USERPROFILE%\\.vscode\\extensions',
      'macos': '~/.vscode/extensions',
      'linux': '~/.vscode/extensions',
    },
  };

  @override
  void installExtension(String extensionName) async => await run('code', ['--install-extension ${extensionName}']);
}
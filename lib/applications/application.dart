// 🎯 Dart imports:
import 'dart:io';

enum ConfigType { settings, extensions }

abstract class Application {
  final name = '';
  final configFilePaths = <ConfigType, Map<String, String>>{
    ConfigType.settings: null,
    ConfigType.extensions: null,
  };

  void stash() async {
    final currentTime = DateTime.now();
    final stashDir = Directory(
        '${Platform.environment['HOME']}/.soc/stash/${this.name}/${currentTime.month}-${currentTime.day}-${currentTime.year}');
    if (!stashDir.existsSync()) {
      stashDir.createSync(recursive: true);
    }

    final settingsFile =
        File(configFilePaths[ConfigType.settings][Platform.operatingSystem]);
    final extensionsDir = Directory(
        configFilePaths[ConfigType.extensions][Platform.operatingSystem]);
    final extensionsDestFile = File('${stashDir.path}/extensions.txt');
    var extensionName = '';

    await settingsFile.copy('${stashDir.path}/settings.json');
    extensionsDestFile.createSync(recursive: true);
    extensionsDir.listSync().forEach((entity) => {
          extensionName = entity.path.split('/').last,
          extensionsDestFile.writeAsStringSync('${extensionName}\n',
              mode: FileMode.append),
        });
  }

  void installExtension(String extensionName) async => {};

  void updateSettings(String settingsFileContents) async {
    final file =
        File(configFilePaths[ConfigType.settings][Platform.operatingSystem]);
    await file.exists().then((bool exists) => {
          if (exists)
            {file.writeAsString(settingsFileContents)}
          else
            {
              file
                  .create()
                  .then((File f) => f.writeAsString(settingsFileContents))
            }
        });
  }
}

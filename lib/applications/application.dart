// 🎯 Dart imports:
import 'dart:io';

enum ConfigType { settings, extensions }

abstract class Application {
  static const name = '';
  final configFilePaths = <ConfigType, Map<String, String>>{
    ConfigType.settings: null,
    ConfigType.extensions: null,
  };

  void stash() async {
    final stashDir = Directory(
        './soc-stash/${name}/${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}');
    await stashDir
        .exists()
        .then((exists) => {if (!exists) stashDir.create(recursive: true)});

    final settingsFile =
        File(configFilePaths[ConfigType.extensions][Platform.operatingSystem]);
    final extensionsFile =
        File(configFilePaths[ConfigType.extensions][Platform.operatingSystem]);

    await settingsFile.copy(
        '${stashDir.path}/${configFilePaths[ConfigType.settings][Platform.operatingSystem]}');
    await extensionsFile.copy(
        '${stashDir.path}/${configFilePaths[ConfigType.extensions][Platform.operatingSystem]}');
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

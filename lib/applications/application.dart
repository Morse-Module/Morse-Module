// 🎯 Dart imports:
import 'dart:io';

enum ConfigType { settings, extensions }

mixin Application {
  var name;
  var settingsFileName;
  final configFilePaths = <ConfigType, Map<String, String>>{
    ConfigType.settings: null,
    ConfigType.extensions: null,
  };

  final stashes = <String>[];

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

    stashes.add('${currentTime.month}-${currentTime.day}-${currentTime.year}');
  }

  void revert({String stashDate}) async {
    final restoreStash = stashDate ?? stashes.last;
    final stashedExtensions = File(
            '${Platform.environment['HOME']}/.soc/stash/${this.name}/${restoreStash}/extensions.txt')
        .readAsLinesSync();
    final stashedSettings =
        '${Platform.environment['HOME']}/.soc/stash/${this.name}/${restoreStash}/${this.settingsFileName}';
    final currentExtensions = <String>[];
    Directory(configFilePaths[ConfigType.extensions][Platform.operatingSystem])
        .listSync()
        .forEach((entity) => currentExtensions.add(entity.path));
    stashedExtensions.forEach((extensionName) => {
          if (!currentExtensions.contains(extensionName))
            {this.installExtension(extensionName)}
        });
    currentExtensions.forEach((extensionName) => {
          if (!stashedExtensions.contains(extensionName))
            {this.uninstallExtension(extensionName)}
        });
    File(stashedSettings).copySync(
        configFilePaths[ConfigType.settings][Platform.operatingSystem]);
  }

  void installExtension(String extensionName) async => {};

  void uninstallExtension(String extensionName) async => {};

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

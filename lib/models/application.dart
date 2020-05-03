// 🎯 Dart imports:
import 'dart:convert';
import 'dart:io';

// 📦 Package imports:
import 'package:process_run/which.dart';
import 'package:morse_module/commands.dart';

// 🌎 Project imports:
import 'package:morse_module/platforms.dart';
import 'package:morse_module/statuses.dart';

abstract class Application {
  // Application name
  final name = '';

  // Executable name: Executable installation help url
  final Map<String, String> commandDependents = {};

  // Terminal command to list all extensions
  final String listExtensions = '';
  // Terminal command to install an extension
  final String installExtension = '';
  // Terminal command to uninstall an extension
  final String uninstallExtension = '';

  // Operating system: File path
  final Map<OperatingSystem, String> configFilePath = {};

  /// Get the path to the home folder for the current os
  static String get homePath {
    if (Platform.isMacOS || Platform.isLinux) {
      return Platform.environment['HOME'];
    }
    // TODO: Implement windows homepath
  }

  /// Check to make sure dependents are installed
  /// If not the user is presented with a helpful url
  void checkDependents(Map<String, String> dependents) {
    for (final dependent in dependents.keys) {
      if (!(whichSync(dependent) is String)) {
        error(
          "Looks like you don't have the command $dependent installed\n See ${dependents[dependent]} for more information",
        );
      }
    }
  }

  /// Stash current config
  void stash() async {
    final stashDir = Directory('$homePath/.morse-module/stash');
    if (!stashDir.existsSync()) {
      stashDir.createSync(recursive: true);
    }

    final folders = stashDir.listSync().whereType<Directory>();

    // Create/remove stash version folders
    Directory currentStashFolder;
    if (folders.contains(Directory(stashDir.path + 'Version-100'))) {
      for (var i = 1; i <= 100; i++) {
        if (i == 1) {
          Directory('$stashDir/Version-1').deleteSync();
        } else {
          Directory('$stashDir/Version-$i')
              .renameSync('$stashDir/Version-${i - 1}');
        }
      }
      currentStashFolder = Directory('$stashDir/Version-100');
    } else {
      for (var i = 1; i <= 100; i++) {
        final newStashDirectory = Directory('$stashDir/Version-$i');
        if (!newStashDirectory.existsSync()) {
          newStashDirectory.createSync();
          currentStashFolder = newStashDirectory;
          break;
        }
      }
    }
    currentStashFolder.createSync();

    // Create json data
    final data = <String, dynamic>{'creationTime': DateTime.now().toString()};
    if (listExtensions != '') {
      final extensions = await convertAndRunCommand(listExtensions);
      data['extensions'] = extensions.split('\n');
    }
    final dataFile = File('$currentStashFolder/data.json');
    dataFile.createSync();
    dataFile.writeAsStringSync(jsonEncode(data));

    // Copy current config file
    final currentConfigFile = File(configFilePath[currentOS()]);
    currentConfigFile
        .copySync('$stashDir/${currentConfigFile.path.split('/').last}');
  }

  /// Revert to a previous config
  void revert({String stashNumber}) async {
    final stashDir = Directory('$homePath/.morseModule/stash');
    final revertDir = stashNumber == null
        ? Directory('$stashDir/Version-$stashNumber')
        : Directory(stashDir.listSync().last.path);
    // Extensions
    final listedExtensions = await convertAndRunCommand(listExtensions);
    final stashedExtensions = jsonDecode(
        File('$revertDir/data.json').readAsStringSync())['extensions'];
    final currentExtensions = listedExtensions.split('\n');
    stashedExtensions.forEach((extensionName) async => {
          if (!currentExtensions.contains(extensionName))
            {convertAndRunCommand('$installExtension $extensionName')}
        });
    currentExtensions.forEach((extensionName) async => {
          if (!stashedExtensions.contains(extensionName))
            {convertAndRunCommand('$uninstallExtension $extensionName')}
        });

    // Config file
    final currentConfigFilePath = File(configFilePath[currentOS()]).path;
    final stashedConfigFile =
        File('$stashDir/${currentConfigFilePath.split('/').last}');
    stashedConfigFile.copySync(currentConfigFilePath);
  }
}

// 🎯 Dart imports:
import 'dart:convert';
import 'dart:io';

// 📦 Package imports:
import 'package:process_run/which.dart';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

// 🌎 Project imports:
import 'package:morse_module/commands.dart';
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

  /// Check to make sure dependents are installed
  /// If not the user is presented with a helpful url
  void checkDependents() {
    for (final dependent in commandDependents.keys) {
      if (!(whichSync(dependent) is String)) {
        error(
          "Looks like you don't have the command $dependent installed\n See ${commandDependents[dependent]} for more information",
        );
      }
    }
  }

  /// Create a dashfile for the application
  void dump({String destination, String url}) async {
    final dashFile = destination != null
        ? File('$destination/dashfile.yaml')
        : File('./dashfile.yaml');
    if (!dashFile.existsSync()) {
      dashFile.createSync(recursive: true);
    }
    var creator = '';
    var repository = '';
    var filepath = '';

    if (url != null) {
      final splitUrl = url.replaceFirst('https://', '').split('/');
      creator = splitUrl[1];
      repository = splitUrl[2];
      for (var i = 5; i < splitUrl.length; i++) {
        if (i > 5) {
          filepath += '/';
        }
        filepath += '${splitUrl[i].replaceAll('%20', ' ')}';
      }
    } else {
      stdout.writeln('What is your GitHub username?');
      creator = await stdin.readLineSync();
      stdout.writeln(
          'What is the name of the GitHub repository you are storing the dotfile in?');
      repository = await stdin.readLineSync();
      stdout.writeln(
          'What is the filepath of the dotfile, relative to the repository root?');
      filepath = await stdin.readLineSync();
    }
    dashFile.writeAsStringSync('application: "$name"\n');
    dashFile.writeAsStringSync('creator: "$creator"\n', mode: FileMode.append);
    dashFile.writeAsStringSync('repository: "$repository"\n',
        mode: FileMode.append);
    dashFile.writeAsStringSync('filepath: "$filepath"\n',
        mode: FileMode.append);
    dashFile.writeAsStringSync('extensions:\n', mode: FileMode.append);
    if (listExtensions != '') {
      final extensions = await convertAndRunCommand(listExtensions);
      extensions.split('\n').forEach((extensionName) => dashFile
          .writeAsStringSync('  - $extensionName\n', mode: FileMode.append));
    }
  }

  /// Stash current config
  void stash() async {
    final stashDir = Directory('${homePath()}/.morse-mod/stash/$name');
    final stashDirPath = stashDir.path;
    if (!stashDir.existsSync()) {
      stashDir.createSync(recursive: true);
    }

    final folders = stashDir.listSync().whereType<Directory>();

    // Create/remove stash version folders
    Directory currentStashFolder;
    if (folders.contains(Directory(stashDirPath + 'Version-100'))) {
      for (var i = 1; i <= 100; i++) {
        if (i == 1) {
          Directory('$stashDirPath/Version-1').deleteSync();
        } else {
          Directory('$stashDirPath/Version-$i')
              .renameSync('$stashDirPath/Version-${i - 1}');
        }
      }
      currentStashFolder = Directory('$stashDirPath/Version-100');
    } else {
      for (var i = 1; i <= 100; i++) {
        final newStashDirectory = Directory('$stashDirPath/Version-$i');
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
    final dataFile = File('${currentStashFolder.path}/data.json');
    dataFile.createSync();
    dataFile.writeAsStringSync(jsonEncode(data));

    // Copy current config file
    final currentConfigFile = File(configFilePath[currentOS()]);
    currentConfigFile.copySync(
      '${currentStashFolder.path}/${currentConfigFile.path.split('/').last}',
    );
  }

  /// Revert to a previous config
  void revert({String stashNumber}) async {
    final stashDir = Directory('${homePath()}/.morse-mod/stash/$name');
    final revertDir = stashNumber != null
        ? Directory('${stashDir.path}/Version-$stashNumber')
        : Directory(stashDir.listSync().last.path);
    // Extensions
    final listedExtensions = await convertAndRunCommand(listExtensions);
    final stashedExtensions = jsonDecode(
        File('${revertDir.path}/data.json').readAsStringSync())['extensions'];
    final currentExtensions = listedExtensions.split('\n');
    currentExtensions.forEach(
      (extensionName) async => {
        if (!stashedExtensions.contains(extensionName))
          {convertAndRunCommand('$uninstallExtension $extensionName')}
      },
    );
    stashedExtensions.forEach(
      (extensionName) async => {
        if (!currentExtensions.contains(extensionName))
          {convertAndRunCommand('$installExtension $extensionName')}
      },
    );

    // Config file
    final currentConfigFilePath = File(configFilePath[currentOS()]).path;
    final stashedConfigFile = File(
      '${revertDir.path}/${currentConfigFilePath.split('/').last}',
    );
    stashedConfigFile.copySync(currentConfigFilePath);
  }

  /// List all the application's stashes' version and creation time
  void listStashes() {
    final stashDir = Directory('${homePath()}/.morse-mod/stash/$name');
    if (stashDir.existsSync() && stashDir.listSync().isNotEmpty) {
      stdout.writeln('Version\tTime Created');

      // Sorting folders
      final sortedFolders = <Directory>[];
      for (var i = 1; i <= 100; i++) {
        if (Directory('${stashDir.path}/Version-$i').existsSync()) {
          sortedFolders.add(Directory('${stashDir.path}/Version-$i'));
        }
      }

      sortedFolders.forEach(
        (entity) {
          final versionNumber =
              int.parse(entity.path.split('/').last.replaceAll('Version-', ''));

          final dataFile = File('${entity.path}/data.json');
          final timeStamp =
              jsonDecode(dataFile.readAsStringSync())['creationTime'];
          stdout.writeln('$versionNumber\t$timeStamp');
        },
      );
    } else {
      error('There are no stashes for the specified application');
    }
  }
}

// 🎯 Dart imports:
import 'dart:convert';
import 'dart:io';

// 📦 Package imports:
import 'package:process_run/which.dart';

// 🌎 Project imports:
import 'package:soc/commands.dart';
import 'package:soc/platforms.dart';
import 'package:soc/statuses.dart';

abstract class Application {
  // Application name
  static const name = '';

  // Executable name: Executable installation help url
  final Map<String, String> commandDependents = {};

  // Terminal command to list all extensions
  final String listExtensions = '';

  // Operating system: File path
  final Map<OperatingSystem, String> filePath = {};

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

  /// Stash current config
  void stash() async {
    final stashDir = Directory('${homePath()}/.soc/stash');
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

    // Copying current file
    final currentFile = File(filePath[currentOS()]);
    currentFile.copySync(
        '${currentStashFolder.path}/${currentFile.path.split('/').last}');
  }
}

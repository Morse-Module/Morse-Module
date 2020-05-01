// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:yaml/yaml.dart';
import 'package:http/http.dart' as http;

// 🌎 Project imports:
import 'package:soc/applications.dart';

/// Install a soc module for an application.
void installSocModule(String socModuleUrl, Application application, {bool noStash}) async {
  // Get the paths for the application's settings
  var fileNames = getPaths(application);
  // Stash the current files based on boolean input
  if (!noStash) {
    _stashFiles(fileNames);
  }
  // Remove existing files
  _removeFiles(fileNames);
  // Read yaml soc_module file from passed url
  var socModule = await http.read(socModuleUrl);
  // Get the data of the dotfile based on the file location from the soc_module file
  var socFile = await http.read(loadYaml(socModule)['file_url']);
  // Write the dotfile data to the config file
  _fileWrite(socFile, fileNames[PathKey.settings]);
  // VSCode extensions
  if (application == Application.vscode) {
    var extensions = loadYaml(socModule)['extensions'];
    _fileWrite(extensions, fileNames[PathKey.extensions]);
  }
}

/// Copy existing files to a stashing directory
void _stashFiles(Map<PathKey, String> filesToStash) => filesToStash.forEach((_, fileName) => File(fileName).copy(''));

void _removeFiles(Map<PathKey, String> filesToRemove) {
  filesToRemove.forEach((_, fileName) => {

  });
}

/// Write data to a file asynchronously.
void _fileWrite(String data, String fileToWrite) async {
  var file = File(fileToWrite);
  await file.exists().then((bool exists) => {
    if (exists) {
      file.writeAsString(data)
    } else {
      file.create().then((File f) => f.writeAsString(data))
    }
  });
}

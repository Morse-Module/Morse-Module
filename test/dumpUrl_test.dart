// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

// 🌎 Project imports:
import 'package:morse_module/models/applicationFactory.dart';

void main() {
  test('Run dump with a url and test yaml output', () {
    ApplicationFactory.getApplication('vscode').dump(
        destination: './test',
        url:
            'https://github.com/Cal-Hagner/Dot-Files/blob/master/Visual%20Studio%20Code/settings.json');
    final output = loadYaml(File('./test/dashfile.yaml').readAsStringSync());
    expect(output['creator'], 'Cal-Hagner');
    expect(output['repository'], 'Dot-Files');
    expect(output['filepath'], 'Visual Studio Code/settings.json');
    File('./test/dashfile.yaml').deleteSync();
  });
}

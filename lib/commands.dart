// 🎯 Dart imports:
import 'dart:io';

// 🌎 Project imports:
import 'package:morse_module/statuses.dart';

Future<String> convertAndRunCommand(String command) async {
  // Split apart command
  final parts = command.split(' ');
  final executable = parts.first;
  final arguments = <String>[...parts.getRange(1, parts.length)];

  final output = await Process.run(executable, arguments);
  if (output.exitCode != 0) {
    print(output.stderr);
    error('Failed to run $executable ${arguments.join(' ')}');
  }
  final lines = output.stdout.toString().split('\n');
  lines.removeLast();
  return lines.join('\n');
}

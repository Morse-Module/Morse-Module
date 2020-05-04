// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:console/console.dart';

/// Output for an error
void error(String message, {int indentation = 0}) {
  final pen = TextPen();
  pen.red();
  pen('${_generateIndentation(indentation)}❌ $message');
  pen();
  exit(64); // Exit code for incorrect usage
}

/// Output for a step in the program
void step(String message, String emoji, {int indentation = 0}) {
  print('${_generateIndentation(indentation)}$emoji $message');
}

/// Output for a successful step
void success(String message, {int indentation = 0}) {
  final pen = TextPen();
  pen.green();
  pen('${_generateIndentation(indentation)}✅ $message');
  pen();
}

/// Generate indentation based of the number of indents
String _generateIndentation(int indentation) {
  final indents = <String>[];
  for (var i = 0; i < indentation; i++) {
    indents.add('    ');
  }
  return indents.join();
}

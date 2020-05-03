// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:console/console.dart';

/// Output for an error
void error(String message) {
  final pen = TextPen();
  pen.red();
  pen('❌ $message');
  pen();
  exit(64); // Exit code for incorrect usage
}

/// Output for a step in the program
void step(String message, String emoji) {
  print('$emoji $message');
}

/// Output for a successful step
void success(String message) {
  final pen = TextPen();
  pen.green();
  pen('✅ $message');
  pen();
}

// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:console/console.dart';

void error(String message) {
  final pen = TextPen();
  pen.red();
  pen('❌ $message');
  pen();
  exit(64); // Exit code for incorrect usage
}

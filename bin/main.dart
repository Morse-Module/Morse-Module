// 🌎 Project imports:
import 'package:morse_module/models/applicationFactory.dart';

void main(List<String> arguments) {
  final application = ApplicationFactory.getApplication('vscode');
  application.checkDependents();
  application.stash();
}

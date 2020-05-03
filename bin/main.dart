// 🌎 Project imports:
import 'package:soc/models/applicationFactory.dart';
import 'package:soc/platforms.dart';

void main(List<String> arguments) {
  final application = ApplicationFactory.getApplication('vscode');
  application.checkDependents();
  application.stash();
}

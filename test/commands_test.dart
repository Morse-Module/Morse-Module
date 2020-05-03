// 📦 Package imports:
import 'package:test/test.dart';

// 🌎 Project imports:
import 'package:soc/commands.dart';

void main() {
  test(
    'Run command and check output',
    () async {
      final output = await convertAndRunCommand('echo Hello World');
      expect(output, 'Hello World\n');
    },
  );
}

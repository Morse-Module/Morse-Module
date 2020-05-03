// 📦 Package imports:
import 'package:test/test.dart';

// 🌎 Project imports:
import 'package:soc/platforms.dart';

void main() {
  test(
    'Simply run the home path and check to make sure it returns a string',
    () {
      final path = homePath();
      expect(path.runtimeType, String);
    },
  );
}

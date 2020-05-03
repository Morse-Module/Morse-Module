// 📦 Package imports:
import 'package:args/command_runner.dart';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

// 🌎 Project imports:
import 'package:morse_module/statuses.dart';

/// Initialize the arg parser
void initParser(List<String> args) => CommandRunner(
    'soc', "Quickly and safely try out other people's editor setups")
  ..addCommand(DumpCommand())
  ..addCommand(InstallCommand())
  ..run(args);

/// Dump command
class DumpCommand extends Command {
  @override
  final name = 'dump';

  @override
  final description =
      'Create a dash file in the current directory for the given editor';

  DumpCommand() {
    argParser.addOption(
      'application',
      help: 'The application to make a dashfile for',
      allowed: [
        'vscode',
      ],
      allowedHelp: {
        'vscode': 'Visual Studio Code',
      },
    );
  }

  @override
  void run() => print(argResults['application']);
}

/// Installation command
class InstallCommand extends Command {
  @override
  final name = 'install';

  @override
  final description = 'Install a dash file';

  InstallCommand() {
    argParser.addOption(
      'url',
      help: 'The url for the dash file on GitHub',
    );
    argParser.addFlag(
      'noStash',
      help: 'If your current config should not be stashed',
      negatable: false,
      defaultsTo: false,
    );
  }

  @override
  void run() async {
    final fixedURL = argResults['url']
        .toString()
        .replaceFirst('github.com', 'raw.githubusercontent.com')
        .replaceAll('/blob', '');
    final contents = await http.get(fixedURL);
    if (contents.statusCode == 200) {
      final yamlContents = loadYaml(contents.body);
    } else {
      error('Failed to download soc module from ${argResults['url']}');
    }
  }
}

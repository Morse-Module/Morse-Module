// 📦 Package imports:
import 'package:args/command_runner.dart';
import 'package:http/http.dart' as http;
import 'package:soc/applications/application.dart';
import 'package:soc/applications/applicationFactory.dart';
import 'package:yaml/yaml.dart';

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
      'Create a dashfile in the current directory for the given editor';

  DumpCommand() {
    argParser.addOption(
      'application',
      help: 'The application to make a module for',
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
  final description = 'Install a dashfile';

  InstallCommand() {
    argParser.addOption(
      'url',
      help: 'URL to the dashfile you want to install',
    );
    argParser.addFlag(
      'noStash',
      help: 'If your current config should be stashed',
      negatable: false,
      defaultsTo: false,
    );
  }

  @override
  void run() async {
    final dashFile = await http.read(argResults['url']);
    final dashFileYaml = loadYaml(dashFile);
    final dotfileUrl =
        'https://raw.githubusercontent.com/${dashFileYaml['user']}/${dashFileYaml['repository']}/${dashFileYaml['filename']}';
    final app =
        ApplicationFactory().getApplication(dashFileYaml['application']);
    await app.stash();
    final socFile = await http.read(dotfileUrl);
    await app.updateSettings(socFile);
    if (app.configFilePaths[ConfigType.extensions] != null) {
      dashFileYaml['extensions']
          .forEach((extensionName) => app.installExtension(extensionName));
    }
  }
}

// 📦 Package imports:
import 'package:args/command_runner.dart';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

// 🌎 Project imports:
import 'package:soc/applications/application.dart';
import 'package:soc/applications/applicationFactory.dart';

/// Initialize the arg parser
void initParser(List<String> args) => CommandRunner(
    'morse-mod', "Quickly and safely try out other people's editor setups")
  ..addCommand(DumpCommand())
  ..addCommand(InstallCommand())
  ..addCommand(RevertCommand())
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
      help: 'If your current config should not be stashed',
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

/// Reversion command
class RevertCommand extends Command {
  @override
  final name = 'revert';

  @override
  final description = 'Revert to a previous configuration';

  RevertCommand() {
    argParser.addOption('application',
        help: 'The application you are reverting to a previous configuration.');
    argParser.addOption(
      'stashDate',
      help:
          'The date of the stash you want to revert to, represented as a string in M-D-YYYY format. If you are unsure which stashes are available, run "ls \$HOME/.soc/stashes/APPLICATION", where application is the application you are reverting to a stash for.',
    );
  }

  @override
  void run() async {
    final app = ApplicationFactory().getApplication(argResults['application']);
    app.revert(stashDate: argResults['stashDate']);
  }
}

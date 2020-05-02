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
      'Create a soc module in the current directory for the given editor';

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
  final description = 'Install a soc module';

  InstallCommand() {
    argParser.addOption(
      'url',
      help: 'URL to the soc module you want to install',
    );
    argParser.addOption(
      'application',
      help: 'The application to install the dotfile to',
      allowed: [
        'vscode'
      ],
      allowedHelp: {
        'vscode': 'Visual Studio Code',
      },
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
    final socModule = await http.read(argResults['url']);
    final socModuleYaml = loadYaml(socModule);
    final socFileUrl = 'https://raw.githubusercontent.com/${socModuleYaml['user']}/${socModuleYaml['repository']}/${socModuleYaml['filename']}';
    final app = ApplicationFactory().getApplication(socModuleYaml['application']);
    await app.stash();
    final socFile = await http.read(socFileUrl);
    await app.updateSettings(socFile);
    if (app.configFilePaths[ConfigType.extensions] != null) socModuleYaml['extensions'].forEach((extensionName) => app.installExtension(extensionName));
  }
}

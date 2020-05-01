// 📦 Package imports:
import 'package:args/command_runner.dart';

/// Initialize the arg parser
void initParser(List<String> args) => CommandRunner(
    'soc', "Quickly and safely try out other people's editor setups")
  ..addCommand(DumpCommand())
  ..addCommand(InstallCommand())
  ..run(args);

class DumpCommand extends Command {
  @override
  final name = 'dump';

  @override
  final description =
      'Create a soc module in the current directory for the given editor';

  DumpCommand() {
    argParser.addOption(
      'editor',
      help: 'The editor to make a module for',
      allowedHelp: {
        'vscode': 'Visual Studio Code Editor',
      },
    );
  }

  @override
  void run() => print(argResults['editor']);
}

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
    argParser.addFlag(
      'noStash',
      help: 'If your current config should be stashed',
      negatable: false,
    );
  }

  @override
  void run() {
    print(argResults['url']);
    print(argResults['noStash']);
  }
}

// 📦 Package imports:
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

// 🌎 Project imports:
import 'package:morse_module/models/application.dart';
import 'package:morse_module/models/applicationFactory.dart';
import 'package:morse_module/statuses.dart';

/// Initialize the arg parser
void initParser(List<String> args) => CommandRunner(
    'morse-mod', "Quickly and safely try out other people's editor setups")
  ..addCommand(DumpCommand())
  ..addCommand(InstallCommand())
  ..addCommand(RevertCommand())
  ..addCommand(ListStashesCommand())
  ..run(args);

/// Dump command
class DumpCommand extends Command {
  @override
  final name = 'dump';

  @override
  final description =
      'Create a dash file in the current directory for the given application using details about the dotfile on GitHub and the local application\'s extensions, if any.';

  DumpCommand() {
    argParser.addOption(
      'application',
      abbr: 'a',
      help: 'The application to make a dash-file for',
      allowed: [
        'vscode',
      ],
      allowedHelp: {
        'vscode': 'Visual Studio Code',
      },
    );
    argParser.addOption(
      'destination',
      abbr: 'd',
      help:
          'The destination directory to add the created dash-file to. If no destination is specified, this command dumps to the current directory.',
    );
    argParser.addOption(
      'url',
      help:
          'The url of the dotfile that the dashfile is being created for. If --url is null, the program proceeds to manual input',
    );
  }

  @override
  void run() {
    final app = ApplicationFactory.getApplication(argResults['application']);
    app.dump(destination: argResults['destination'], url: argResults['url']);
  }
}

/// Installation command
class InstallCommand extends Command {
  @override
  final name = 'install';

  @override
  final description = 'Install a dash-file';

  InstallCommand() {
    argParser.addOption(
      'url',
      help: 'The url for the dash-file on GitHub',
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
        .replaceAll('/blob/', '/');
    final contents = await http.get(fixedURL);
    if (contents.statusCode == 200) {
      final yamlContents = loadYaml(contents.body);
    } else {
      error('Failed to download dash-file from ${argResults['url']}');
    }
  }
}

class RevertCommand extends Command {
  @override
  final name = 'revert';

  @override
  final description = 'Revert to a stashed configuration';

  RevertCommand() {
    argParser.addOption(
      'application',
      abbr: '-a',
      help: 'The application to revert to a previous configuration',
      allowed: [
        'vscode',
      ],
      allowedHelp: {
        'vscode': 'Visual Studio Code',
      },
    );
    argParser.addOption(
      'version',
      abbr: 'v',
      help: 'The number representing the version of the stash',
      defaultsTo: '',
    );
  }

  @override
  void run() {
    final app = ApplicationFactory.getApplication(argResults['application']);
    app.revert(stashNumber: argResults['version']);
  }
}

class ListStashesCommand extends Command {
  @override
  final name = 'list-stashes';

  @override
  final description = 'List current stashes for the specified application';

  ListStashesCommand() {
    argParser.addOption(
      'application',
      help: 'The application to list stashes for',
      allowed: [
        'vscode',
      ],
      allowedHelp: {
        'vscode': 'Visual Studio Code',
      },
      defaultsTo: '',
    );
  }

  @override
  void run() {
    final app = ApplicationFactory.getApplication(argResults['application']);
    app.listStashes();
  }
}

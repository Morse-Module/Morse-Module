import 'package:args/args.dart';
import 'package:args/command_runner.dart';

/// Initialize the arg parser
void initParser(List<String> args) {
  var runner = CommandRunner(
      'soc', "Quickly and safely try out other people's editor setups")
    ..addCommand(DumpCommand())
    ..run(args);
}

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
  void run() {
    print('yay!');
  }
}

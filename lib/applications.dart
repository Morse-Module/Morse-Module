// 🎯 Dart imports:
import 'dart:io';

enum Application { vscode }

const Map <String, Application> applications = {
  'vscode': Application.vscode,
};

enum PathKey { settings, extensions }

const Map<Application, Map<String, Map<PathKey, String>>> _applicationPaths = {
  Application.vscode: {
    'windows': {
      PathKey.settings: '%APPDATA%\\Code\\User\\settings.json', 
      PathKey.extensions: '%USERPROFILE%\\.vscode\\extensions',
    }, 
    'macos': {
      PathKey.settings: '\$HOME/Library/Application Support/Code/User/settings.json', 
      PathKey.extensions: '~/.vscode/extensions',
    }, 
    'linux': {
      PathKey.settings: '\$HOME/.config/Code/User/settings.json', 
      PathKey.extensions: '~/.vscode/extensions',
    },
  },
};

/// Return the platform-specific setting path(s) for an application
Map<PathKey, String> getPaths(Application application) => _applicationPaths[application][Platform.operatingSystem];

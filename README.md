# Morse-Module

![Dart CI](https://github.com/Morse-Module/Morse-Module/workflows/Dart%20CI/badge.svg)

🚀 Platform to quickly share application config files and try them out risk free. Similar to homebrew cask but for configs

## ❓ How it works

1. 🤝 You give the url of a dash-file (see below for what a dash-file is)
2. 📦 Morse-Module stores the current version of your config in a safe place so you can revert back if stuff breaks
3. 🚀 Morse-Module installs config defined in dash-file
4. 😄 You're all set up! No extra install setups 🙌

## 📦 Dash-files

A dash-file is a file in a yaml format that outlines a config that you can install. Below is an example of a dash-file:

```yml
application: "vscode"
creator: "Matt-Gleich"
repository: "Dot-Files"
filepath: "VSCode/settings.json"
extensions:
  - bierner.markdown-emoji
  ...
```

For more information regarding dash-files, please reference [the usage documentation](docs/USAGE.md).

## Application Support

| Application        | 🐧 Linux (Debian-based) | 🍏 MacOS | 🖼️ Windows |
| ------------------ | ---------------------- | ------- | --------- |
| Visual Studio Code | ✅                      | ✅       | ✅         |

## 🙋‍♀️🙋‍♂️ Contributing

Contributions of application support, documentation upgrades, typo fixes (we all make them), and general features are all welcome! Please see [the contributing guidelines](docs/CONTRIBUTING.md) and [the code of conduct](docs/CODE_OF_CONDUCT.md) for more information.

## 😄 Contributors

- Matthew Gleich, co-founder ([@Matt-Gleich](https://github.com/Matt-Gleich))
- Caleb Hagner, co-founder ([@Cal-Hagner](https://github.com/Cal-Hagner))

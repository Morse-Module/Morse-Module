# Morse-Module

🚀 Platform to quickly share application dot-files and try them out risk free. Similar to homebrew cask but for dot-files.

## ❓ How it works

1. 🤝 You give the url of a dash-file (see below)
2. 📦 Stores current version of config is safe place so you can revert back if stuff breaks
3. 🚀 Install config defined in dash-file
4. 😄 You're all set up! No extra install setups 🙌

## 📦 dash-file

A dash-file is a file in a yaml format that outlines a config you can install. Below is an example of a dash-file:

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

## Contributing

Contributions of application support, documentation upgrades, typo fixes (we all make them), or SOC features are all welcome. Please see [the contributing guidlines](docs/CONTRIBUTING.md) and [the code of conduct](docs/CODE_OF_CONDUCT.md) for more information.

## 😄 Contributors

- Matthew Gleich ([@Matt-Gleich](https://github.com/Matt-Gleich))
- Caleb Hagner ([@Cal-Hagner](https://github.com/Cal-Hagner))

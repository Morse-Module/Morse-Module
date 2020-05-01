# Share-Open-Configs

🚀 Platform to quickly share application config files and try them out risk free. Similar to homebrew cask but for configs

## ❓ How it works

1. 🤝 You give url for soc-module (look down below for what a soc-module is)
2. 📦 Stores current version of config is safe place so you can revert back if stuff breaks
3. 🚀 Install and use config defined in soc-module
4. 😄 Your all setup! No any extra install setups 🙌

## 📦 soc-module

A soc-module is a file in a yaml format that outlines a config you can install. Below is an example of a soc-module:

```yml
application: 'vscode'
owner: 'Matthew Gleich (Matt-Gleich)'
file_url: 'https://github.com/Matt-Gleich/Dot-Files/VSCode/settings.json'
location: '~/Library/Application Support/Code/User/settings.json'
extensions:
  - 
```

## 😄 Contributors

- Matthew Gleich (@Matt-Gleich)
- Caleb Hanger (@Cal-Hagner)

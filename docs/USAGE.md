# How to Use Morse-Module

## Commands

| Command Name   | Options                                                                                                                                                                                                                                                                                                                                                               | Flags                                                           |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| `dump`         | `--application`, `-a`: The application to make a dash-file for.<br>`--destination`, `-d`: The destination directory to add the created dash-file to. If no destination is specified, this command dumps to the current directory.<br>`--url`: The url of the dotfile that the dash-file is being created for. If --url is null, the program proceeds to manual input. | N/A                                                             |
| `list-stashes` | `--application`, `-a`: The application to list stashes for.                                                                                                                                                                                                                                                                                                           | N/A                                                             |
| `revert`       | `--application`, `-a`: The application to revert to a previous configuration.<br><br>`--version`, `-v`: The number representing the version of the stash (1-100)                                                                                                                                                                                                      | N/A                                                             |
| `install`      | `--url`: The url for the dash-file on GitHub                                                                                                                                                                                                                                                                                                                          | `-nostash`: If your current configuration should not be stashed |

## Writing a dash-file

> Rather than write a dash-file manually, you can run `morse-mod dump --help` for information on how to use Morse-Module to automatically generate one.

Dash-files are the `.yaml` format file that defines the dot-file that can be installed via Morse.

A dash-file must contain the following keys:

- `application`: The application for the which the dot-file is for
- `creator`: The username of the GitHub user whose repository contains the dot-file
- `repository`: The repository in which the dot-file exists
- `filepath`: The path of the dot-file, relative to the repository root

Depending on the nature of the application for the dot-file is for, the dash-file may need one or more of the following keys:

- `extensions`: A list of extension names (e.g. `bierner.markdown-emoji` for Visual Studio Code) in whatever format the application provides extensions.

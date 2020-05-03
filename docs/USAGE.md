# How to Use Morse

## Writing a dash-file

Dash-files are the `.yaml` format file that defines the dot-file that can be installed via Morse.

A dash-file must contain the following keys:

- `application`: The application for the which the dot-file is for
- `creator`: The username of the GitHub user whose repository contains the dot-file
- `repository`: The repository in which the dot-file exists
- `filepath`: The path of the dot-file, relative to the repository root

Depending on the nature of the application for the dot-file is for, the dash-file may need one or more of the following keys:

- `extensions`: A list of extension names (e.g. `bierner.markdown-emoji` for Visual Studio Code) in whatever format the application provides extensions.

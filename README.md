# RYUJIN System Control

**A Linux desktop system monitoring and hardware control application built with Python and PySide6.**

RYUJIN System Control provides a graphical interface for monitoring system information and accessing supported hardware controls on Linux. Its installer sets up a convenient `ryujin` command to install, launch, update, and uninstall the packaged application.

## Features

- **System Monitoring** — View system resource information.
- **Hardware Information** — Access hardware details supported by the application.
- **Linux Desktop GUI** — Built with Python and PySide6.
- **User-local Installation** — Installs the packaged application under `~/.local/opt/ryujin-system-control/`.
- **Command-line Launcher** — Launch the application using `ryujin run`.
- **Install and Update** — Install or replace the application using a release archive.
- **Uninstall Support** — Remove the installed application using the CLI.
- **Bash and Zsh Support** — Configure `~/.bashrc` or `~/.zshrc` to include `~/.local/bin` in your PATH.

*Available monitoring and hardware-control features depend on the application's implementation, Linux distribution, hardware, and permissions.*

## Technology Stack

- Python
- PySide6 / Qt
- psutil
- PyInstaller
- Bash scripting

## System Requirements

- A compatible Linux desktop environment
- An x86_64 system for the provided Linux release archive
- Bash or Zsh for the installer
- `tar` for extracting the application archive
- Python 3 and pip if running from source

## Download

Download the latest packaged application from [RYUJIN System Control Releases](https://github.com/whilehat/ryujin-system-control/releases).

The release archive is expected to be named:

`RYUJIN-System-Control-linux-x86_64.tar.gz`

## Installation

### Option 1: Install using the RYUJIN installer

Download these files from the repository or its Releases page:

- `install-ryujin.sh`
- `RYUJIN-System-Control-linux-x86_64.tar.gz`

Place both files in your Downloads directory.

Open a terminal and run:

```bash
cd ~/Downloads
chmod +x install-ryujin.sh
./install-ryujin.sh
```

The installer will:

1. Detect your current shell when possible.
2. Ask which shell configuration to update.
3. Create the `~/.local/bin/ryujin` command.
4. Add `~/.local/bin` to the selected shell configuration, if requested.
5. Install the application if the release archive is in Downloads.

If the archive is not found, the installer configures the command and tells you how to install the application later.

After installation, open a new terminal or source the shell configuration file printed by the installer.

### Option 2: Install the application later

If you downloaded the archive after running the installer, use:

```bash
ryujin install ~/Downloads/RYUJIN-System-Control-linux-x86_64.tar.gz
```

You can also supply the path to an archive stored elsewhere.

## Usage

### Launch the application

```bash
ryujin run
```

### Install an application archive

```bash
ryujin install /path/to/RYUJIN-System-Control-linux-x86_64.tar.gz
```

### Update the application

```bash
ryujin update /path/to/RYUJIN-System-Control-linux-x86_64.tar.gz
```

The update command replaces the existing installation with the application contained in the supplied archive. Keep a copy of the previous archive if you may need to roll back.

### Uninstall the application

```bash
ryujin uninstall
```

This removes the installed application directory. It does not remove the installer script or automatically undo PATH changes in your shell configuration.

### Show available commands

```bash
ryujin help
```

## Installation Locations

| Component | Location |
|---|---|
| CLI command | `~/.local/bin/ryujin` |
| Application directory | `~/.local/opt/ryujin-system-control/RYUJIN-System-Control/` |
| Bash configuration | `~/.bashrc` |
| Zsh configuration | `~/.zshrc` |
| Shell configuration backups | Original configuration filename followed by `.bak.TIMESTAMP` |

The installer does not require root privileges for its user-local installation.

## Run from Source

To run the Python application directly, clone the repository:

```bash
git clone https://github.com/whilehat/ryujin-system-control.git
cd ryujin-system-control
```

Create a virtual environment and install the project's dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Start the application:

```bash
python main.py
```

These commands assume that `main.py` and `requirements.txt` are included in the repository.

## Project Structure

```text
ryujin-system-control/
├── main.py
├── requirements.txt
├── install-ryujin.sh
├── README.md
├── .gitignore
└── LICENSE
```

This is an example structure. Include any additional source modules and assets required by your application.

## Security and Compatibility Notes

- Review scripts before running them on your system.
- The installer creates and modifies files within your home directory.
- Shell configuration changes are backed up before modification.
- The packaged release is intended for compatible x86_64 Linux systems.
- Hardware-control functionality may require additional system utilities or permissions.
- The installer expects the release archive to contain the `RYUJIN-System-Control/` directory and its executable.

## Contributing

Contributions, bug reports, and feature suggestions are welcome.

1. Fork the repository.
2. Create a branch for your changes.
3. Implement and test your changes.
4. Submit a pull request.

## Bug Reports

Report bugs and request features through [GitHub Issues](https://github.com/whilehat/ryujin-system-control/issues).

## License

See the `LICENSE` file for the applicable license.

---

**RYUJIN System Control** — System monitoring and hardware control for Linux.

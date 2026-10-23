# RYUJIN System Control

**Linux System Monitoring and Hardware Control**

RYUJIN System Control is a Linux desktop application built with Python and PySide6. It provides a graphical interface for viewing system information and accessing supported hardware controls.

The project includes a packaged Linux application and a Bash installer that configures a convenient `ryujin` command for managing the installation.

## Features

- **System Monitoring** — View system resource information.
- **Hardware Information** — Access hardware information supported by the application.
- **Desktop Interface** — A graphical user interface built with PySide6 and Qt.
- **Packaged Application** — Run the bundled application without manually installing its Python dependencies.
- **Simple Installation** — Install the application using the provided shell installer.
- **Command-line Management** — Install, launch, update, and uninstall the application using the `ryujin` command.
- **Bash and Zsh Support** — Configure the shell PATH for convenient access to the command.

Hardware information and controls depend on the implemented features, hardware, Linux distribution, and required permissions.

## Technology Stack

- Python
- PySide6 / Qt
- psutil
- PyInstaller
- Bash

## System Requirements

- A compatible Linux desktop environment.
- An x86_64 Linux system for the provided release build.
- Bash or Zsh to configure the shell environment.
- `tar` to extract the application archive.

Running from source additionally requires Python 3 and pip.

## Download

Download the latest release from:

**[RYUJIN System Control — GitHub Releases](https://github.com/whilehat/ryujin-system-control/releases)**

Download these files:

- `install-ryujin.sh`
- `RYUJIN-System-Control-linux-x86_64.tar.gz`

The application archive should contain the `RYUJIN-System-Control/` directory directly at its root, including the executable and `_internal/` directory.

Expected archive structure:

```text
RYUJIN-System-Control-linux-x86_64.tar.gz
└── RYUJIN-System-Control/
    ├── RYUJIN-System-Control
    └── _internal/
        └── ...
```

## Installation

### Method 1: Install using the installer script

Download both files and place them in your Downloads directory.

Open a terminal and run:

```bash
cd ~/Downloads
chmod +x install-ryujin.sh
./install-ryujin.sh
```

The installer will:

1. Detect your current shell when possible.
2. Ask which shell configuration should be updated.
3. Create the `ryujin` command in `~/.local/bin/`.
4. Add `~/.local/bin` to the selected shell configuration, if requested.
5. Install the application if the expected archive is present in Downloads.

The installer creates a backup before modifying an existing shell configuration file.

If the archive is not found, the installer still configures the command and displays instructions for installing the application later.

After setup, open a new terminal or reload the appropriate shell configuration file.

### Method 2: Install the application later

If you download the archive after running the installer, execute:

```bash
ryujin install ~/Downloads/RYUJIN-System-Control-linux-x86_64.tar.gz
```

You can also supply an archive stored elsewhere:

```bash
ryujin install /path/to/RYUJIN-System-Control-linux-x86_64.tar.gz
```

## Usage

### Launch the application

```bash
ryujin run
```

### Install the application

```bash
ryujin install /path/to/archive.tar.gz
```

### Update the application

```bash
ryujin update /path/to/archive.tar.gz
```

The update command replaces the existing application installation with the version contained in the supplied archive.

### Uninstall the application

```bash
ryujin uninstall
```

This removes the installed application directory. It does not automatically remove the `ryujin` command or revert shell PATH modifications.

### Display help

```bash
ryujin help
```

## Installation Locations

| Component | Location |
|---|---|
| Command-line launcher | `~/.local/bin/ryujin` |
| Application installation | `~/.local/opt/ryujin-system-control/` |
| Bash configuration | `~/.bashrc` |
| Zsh configuration | `~/.zshrc` |

The application is installed in the current user's home directory and does not normally require root privileges for installation.

## Run from Source

Clone the repository:

```bash
git clone https://github.com/whilehat/ryujin-system-control.git
cd ryujin-system-control
```

Create a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Run the application:

```bash
python main.py
```

These instructions assume that `main.py` and `requirements.txt` are included in the repository.

## Compatibility

The packaged release targets x86_64 Linux systems. Compatibility with individual distributions, desktop environments, hardware, and system libraries may vary.

Some hardware-related features may require additional Linux utilities or permissions.

## Troubleshooting

**The `ryujin` command is not found**

Open a new terminal or reload your shell configuration:

For Bash:

```bash
source ~/.bashrc
```

For Zsh:

```bash
source ~/.zshrc
```

**The application is not installed**

Download the release archive and run:

```bash
ryujin install ~/Downloads/RYUJIN-System-Control-linux-x86_64.tar.gz
```

**The installer rejects the archive**

Check that `RYUJIN-System-Control/` is the top-level directory inside the archive and that it contains the executable named `RYUJIN-System-Control`.

**The application does not launch**

Check the terminal output for missing shared libraries, incompatible system dependencies, or permission issues.

## Contributing

Contributions, bug reports, and feature suggestions are welcome.

1. Fork the repository.
2. Create a branch for your changes.
3. Implement and test your changes.
4. Submit a pull request.

## Bug Reports and Feature Requests

Open an issue through [GitHub Issues](https://github.com/whilehat/ryujin-system-control/issues).

## License

See the `LICENSE` file in this repository for the applicable license.

---

**RYUJIN System Control**  
*System monitoring and hardware control for Linux.*

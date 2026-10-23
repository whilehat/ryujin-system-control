# RYUJIN System Control

A Linux desktop application for system monitoring and hardware control, built with Python and PySide6.

## Overview

**RYUJIN System Control** is a desktop utility designed to provide a graphical interface for viewing system information and accessing supported hardware controls on Linux.

The project aims to make essential system information accessible through a simple desktop interface.

## Features

- **System Monitoring** — View system resource information.
- **Hardware Information** — Inspect available hardware details.
- **CPU and GPU Information** — Display processor and graphics information where supported.
- **Hardware Controls** — Access supported controls depending on your hardware and Linux configuration.
- **Linux Desktop GUI** — Built using Python and PySide6.
- **Standalone Build** — A packaged Linux application is available through GitHub Releases.

*Feature availability may vary depending on your Linux distribution, hardware, permissions, and installed system utilities.*

## Technology Stack

- Python
- PySide6 / Qt
- psutil
- PyInstaller

## Requirements

For running from source:

- Linux operating system
- Python 3
- pip
- Git

Some hardware-related features may require additional Linux utilities or permissions.

## Installation

### Option 1: Download the packaged application

1. Open the [Releases](https://github.com/whilehat/ryujin-system-control/releases) page.
2. Download `RYUJIN-System-Control-linux-x86_64.tar.gz`.
3. Extract the archive using your file manager.
4. Open the extracted `RYUJIN-System-Control` folder.
5. Run the `RYUJIN-System-Control` executable.

If the application does not launch, check the terminal output for missing system libraries or permissions.

The packaged build is intended for compatible **x86_64 Linux systems**.

### Option 2: Run from source

Clone the repository:

```bash
git clone https://github.com/whilehat/ryujin-system-control.git
cd ryujin-system-control
```

Create and activate a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install the dependencies:

```bash
pip install -r requirements.txt
```

Run the application:

```bash
python main.py
```

## Project Structure

```text
ryujin-system-control/
├── main.py
├── requirements.txt
├── README.md
├── .gitignore
└── LICENSE
```

*The structure above is illustrative. Additional modules and assets may be present in the actual project.*

## Compatibility

RYUJIN System Control is developed for Linux desktop environments. Compatibility with individual distributions, desktop environments, GPUs, and hardware-control interfaces may vary.

## Contributing

Contributions, bug reports, and feature suggestions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Test your changes.
5. Submit a pull request.

## Issues and Feedback

To report a bug or suggest a feature, visit the [GitHub Issues](https://github.com/whilehat/ryujin-system-control/issues) page.

## License

See the [LICENSE](LICENSE) file for licensing information.

---

**RYUJIN System Control** — Linux system monitoring and hardware control.

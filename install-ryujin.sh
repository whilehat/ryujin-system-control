#!/usr/bin/env bash
# RYUJIN System Control bootstrap installer
# Supports Bash and Zsh. Installs a user-local "ryujin" command.

set -Eeuo pipefail

APP_NAME="RYUJIN-System-Control"
INSTALL_DIR="${HOME}/.local/opt/ryujin-system-control"
APP_DIR="${INSTALL_DIR}/${APP_NAME}"
BIN_DIR="${HOME}/.local/bin"
COMMAND_PATH="${BIN_DIR}/ryujin"

info() { printf '\033[1;36m[RYUJIN]\033[0m %s\n' "$*" >&2; }
warn() { printf '\033[1;33m[RYUJIN]\033[0m %s\n' "$*" >&2; }
die() { printf '\033[1;31m[RYUJIN ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<'HELP'
RYUJIN System Control installer

Usage:
  ./install-ryujin.sh [archive.tar.gz]

The script:
  - Detects Bash/Zsh when possible
  - Asks which shell configuration to update if detection is unclear
  - Creates ~/.local/bin/ryujin
  - Adds ~/.local/bin to selected shell startup file(s)
  - Installs the app if an archive is supplied or found in Downloads

After setup:
  ryujin install [archive.tar.gz]
  ryujin run
  ryujin update [archive.tar.gz]
  ryujin uninstall
  ryujin help
HELP
}

detect_current_shell() {
    local candidate=""
    # If sourced, these variables reliably identify the current shell.
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        printf 'zsh\n'; return 0
    elif [[ -n "${BASH_VERSION:-}" ]]; then
        printf 'bash\n'; return 0
    fi

    # When executed normally, the parent process is usually the invoking shell.
    candidate="$(ps -p "$PPID" -o comm= 2>/dev/null | tr -d '[:space:]' || true)"
    case "${candidate##*/}" in
        zsh) printf 'zsh\n'; return 0 ;;
        bash) printf 'bash\n'; return 0 ;;
    esac

    # SHELL is the login shell, which is a useful fallback.
    case "${SHELL##*/}" in
        zsh) printf 'zsh\n'; return 0 ;;
        bash) printf 'bash\n'; return 0 ;;
    esac
    return 1
}

SELECTED_SHELL=""

choose_shells() {
    local detected="${1:-}" choice
    if [[ -n "$detected" ]]; then
        info "Detected your current shell: ${detected}"
        printf 'Which shell configuration should be updated?\n' >&2
        printf '  1) Use detected shell (%s)\n' "$detected" >&2
        printf '  2) Bash (~/.bashrc)\n' >&2
        printf '  3) Zsh (~/.zshrc)\n' >&2
        printf '  4) Both Bash and Zsh\n' >&2
        printf '  5) Skip shell configuration\n' >&2
    else
        warn "Could not reliably detect the current shell."
        printf 'Choose the shell configuration to update:\n' >&2
        printf '  1) Bash (~/.bashrc)\n' >&2
        printf '  2) Zsh (~/.zshrc)\n' >&2
        printf '  3) Both Bash and Zsh\n' >&2
        printf '  4) Skip shell configuration\n' >&2
    fi

    while true; do
        read -r -p "Enter choice [1]: " choice
        choice="${choice:-1}"
        if [[ -n "$detected" ]]; then
            case "$choice" in
                1) SELECTED_SHELL="$detected"; return ;;
                2) SELECTED_SHELL="bash"; return ;;
                3) SELECTED_SHELL="zsh"; return ;;
                4) SELECTED_SHELL="both"; return ;;
                5) SELECTED_SHELL="skip"; return ;;
            esac
        else
            case "$choice" in
                1) SELECTED_SHELL="bash"; return ;;
                2) SELECTED_SHELL="zsh"; return ;;
                3) SELECTED_SHELL="both"; return ;;
                4) SELECTED_SHELL="skip"; return ;;
            esac
        fi
        warn "Please enter one of the listed choices."
    done
}

add_path_to_file() {
    local rc="$1"
    local marker="# RYUJIN System Control PATH"
    mkdir -p "$(dirname "$rc")"
    touch "$rc"

    if grep -Fq "$marker" "$rc"; then
        info "PATH setup already exists in ${rc}; leaving it unchanged."
        return
    fi

    cp -p "$rc" "${rc}.bak.$(date +%Y%m%d%H%M%S)"
    cat >> "$rc" <<'BLOCK'

# RYUJIN System Control PATH
case ":$PATH:" in
  *:"$HOME/.local/bin":*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
BLOCK
    info "Updated ${rc} (a backup was created)."
}

write_cli() {
    mkdir -p "$BIN_DIR" "$(dirname "$INSTALL_DIR")"

    cat > "$COMMAND_PATH" <<'CLI'
#!/usr/bin/env bash
set -Eeuo pipefail

APP_NAME="RYUJIN-System-Control"
INSTALL_DIR="${HOME}/.local/opt/ryujin-system-control"
APP_DIR="${INSTALL_DIR}/${APP_NAME}"

usage() {
    cat <<'HELP'
RYUJIN System Control CLI

Usage:
  ryujin install [archive.tar.gz]  Install the downloaded app
  ryujin run                       Launch the app
  ryujin update [archive.tar.gz]   Replace with a newer archive
  ryujin uninstall                 Remove the installed app
  ryujin help                      Show this help

If no archive is given, searches ~/Downloads and the current directory.
HELP
}

find_archive() {
    local candidate
    for candidate in \
        "$HOME/Downloads/RYUJIN-System-Control-linux-x86_64.tar.gz" \
        "$PWD/RYUJIN-System-Control-linux-x86_64.tar.gz"
    do
        if [[ -f "$candidate" ]]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done
    return 1
}

install_app() {
    local archive="${1:-}" tmp new backup entry
    if [[ -z "$archive" ]]; then
        archive="$(find_archive)" || {
            echo "Archive not found. Download RYUJIN-System-Control-linux-x86_64.tar.gz first."
            echo "Then run: ryujin install /path/to/archive.tar.gz"
            exit 1
        }
    fi
    [[ -f "$archive" ]] || { echo "Archive not found: $archive" >&2; exit 1; }
    command -v tar >/dev/null || { echo "tar is required." >&2; exit 1; }

    # Reject absolute paths, traversal paths, and unexpected top-level entries.
    while IFS= read -r entry; do
        case "$entry" in
            "$APP_NAME"|"$APP_NAME/"|"$APP_NAME/"*)
                if [[ "$entry" == /* || "$entry" == ../* ||
                      "$entry" == *"/../"* || "$entry" == *"/.." ]]; then
                    echo "Unsafe archive path: $entry" >&2; exit 1
                fi
                ;;
            *) echo "Unexpected archive entry: $entry" >&2; exit 1 ;;
        esac
    done < <(tar -tzf "$archive")

    tar -tzf "$archive" | grep -Fxq "$APP_NAME/$APP_NAME" || {
        echo "Archive does not contain the expected application executable." >&2
        exit 1
    }

    tmp="$(mktemp -d)"
    new="${INSTALL_DIR}.new.$$"
    backup="${INSTALL_DIR}.backup.$$"
    cleanup() { rm -rf "$tmp" "$new"; }
    trap cleanup EXIT

    echo "Extracting release..."
    tar --no-same-owner -xzf "$archive" -C "$tmp"
    [[ -f "$tmp/$APP_NAME/$APP_NAME" ]] || {
        echo "Executable missing after extraction." >&2; exit 1;
    }
    mkdir -p "$(dirname "$INSTALL_DIR")" "$new"
    cp -a "$tmp/$APP_NAME" "$new/"
    chmod u+x "$new/$APP_NAME/$APP_NAME"

    if [[ -e "$INSTALL_DIR" ]]; then mv "$INSTALL_DIR" "$backup"; fi
    if mv "$new" "$INSTALL_DIR"; then
        rm -rf "$backup"
    else
        [[ ! -e "$backup" ]] || mv "$backup" "$INSTALL_DIR"
        echo "Install failed; previous version restored." >&2
        exit 1
    fi

    trap - EXIT
    rm -rf "$tmp" "$new"
    echo "RYUJIN System Control installed."
    echo "Launch it with: ryujin run"
}

case "${1:-help}" in
    install) shift; install_app "${1:-}" ;;
    update) shift; install_app "${1:-}" ;;
    run|start)
        [[ -x "$APP_DIR/$APP_NAME" ]] || {
            echo "App not installed. Run: ryujin install" >&2; exit 1;
        }
        cd "$APP_DIR"
        exec "./$APP_NAME"
        ;;
    uninstall)
        if [[ -d "$INSTALL_DIR" ]]; then
            rm -rf -- "$INSTALL_DIR"
            echo "RYUJIN System Control removed."
        else
            echo "RYUJIN System Control is not installed."
        fi
        ;;
    help|-h|--help) usage ;;
    *) echo "Unknown command: $1" >&2; usage; exit 2 ;;
esac
CLI
    chmod 755 "$COMMAND_PATH"
    info "Created ${COMMAND_PATH}"
}

main() {
    if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then usage; exit 0; fi
    local archive="${1:-}" detected="" selected="" rc=""
    detected="$(detect_current_shell || true)"
    choose_shells "$detected"
    selected="$SELECTED_SHELL"

    write_cli

    case "$selected" in
        bash) add_path_to_file "$HOME/.bashrc" ;;
        zsh) add_path_to_file "$HOME/.zshrc" ;;
        both)
            add_path_to_file "$HOME/.bashrc"
            add_path_to_file "$HOME/.zshrc"
            ;;
        skip) warn "Skipped shell configuration. Add ~/.local/bin to PATH manually." ;;
    esac

    if [[ -n "$archive" ]]; then
        "$COMMAND_PATH" install "$archive"
    elif [[ -f "$HOME/Downloads/RYUJIN-System-Control-linux-x86_64.tar.gz" ]]; then
        "$COMMAND_PATH" install "$HOME/Downloads/RYUJIN-System-Control-linux-x86_64.tar.gz"
    else
        info "No release archive found in Downloads; command setup is complete."
        info "Download the archive, then run: ryujin install"
    fi

    printf '\n'
    info "Setup finished."
    if [[ "$selected" == "bash" ]]; then
        printf 'To update this terminal now, run: source "%s"\n' "$HOME/.bashrc"
    elif [[ "$selected" == "zsh" ]]; then
        printf 'To update this terminal now, run: source "%s"\n' "$HOME/.zshrc"
    elif [[ "$selected" == "both" ]]; then
        printf 'For this terminal, run the source command for your shell: ~/.bashrc or ~/.zshrc\n'
    fi
    printf 'Then launch with: ryujin run\n'
    printf 'Note: a script cannot change its parent terminal environment; sourcing the config or opening a new terminal applies PATH.\n'
}

main "$@"

#!/bin/bash
set -e

VERSION="2.0.5"

REPO="pandev-metriks/homebrew-pandev-cli"
TAP="pandev-metriks/pandev-cli"
FORMULA="$TAP/pandev-cli-plugin"

BETA_TAP="pandev-metriks/pandev-cli-beta"

INSTALL_DIR="$HOME/.pandev"
BIN_DIR="$HOME/.local/bin"
BIN_LINK="$BIN_DIR/pandev"

# -------------------------------------------------------
# 1. Root check
# -------------------------------------------------------
if [ "$(id -u)" -eq 0 ]; then
    echo "ERROR: Do not run this script as root."
    exit 1
fi

# -------------------------------------------------------
# 2. Detect OS and architecture
# -------------------------------------------------------
OS=$(uname -s)
ARCH=$(uname -m)

case "$ARCH" in
    x86_64) ARCH_NAME="amd64" ;;
    arm64|aarch64) ARCH_NAME="arm64" ;;
    *) echo "ERROR: Unsupported architecture: $ARCH"; exit 1 ;;
esac

case "$OS" in
    Darwin) OS_NAME="macOS" ;;
    Linux)  OS_NAME="Linux" ;;
    *) echo "ERROR: Unsupported OS: $OS"; exit 1 ;;
esac

echo "Platform detected: $OS_NAME / $ARCH_NAME"

# -------------------------------------------------------
# 3. macOS Command Line Tools check
# -------------------------------------------------------
if [[ "$OS" == "Darwin" ]]; then
    if ! xcode-select -p &>/dev/null; then
        echo "Command Line Tools not found."
        sudo xcode-select --install
        echo ""
        echo "Please complete installation and re-run this script."
        exit 0
    fi
fi

# -------------------------------------------------------
# 4. Helpers: save / restore login data
# -------------------------------------------------------
TMP_DIR=""
CREDS_BACKUP=$(mktemp -d)

cleanup() {
    local exit_code=$?
    [ -n "$TMP_DIR" ] && rm -rf "$TMP_DIR"
    rm -rf "$CREDS_BACKUP"
    if [ "$exit_code" -ne 0 ]; then
        echo "" >&2
        echo "==================================================================" >&2
        echo "ERROR: Installation failed." >&2
        echo "" >&2
        echo "If this looks like a network issue (timeout, connection error)," >&2
        echo "please check your internet connection and try again in a few minutes." >&2
        echo "" >&2
        echo "If the problem persists, contact the pandev-cli team." >&2
        echo "==================================================================" >&2
    fi
}
trap cleanup EXIT

save_login_data() {
    if [ ! -d "$INSTALL_DIR" ]; then
        return
    fi
    echo "Saving login data..."
    find "$INSTALL_DIR" -maxdepth 3 -type f \( \
        -name "*.json" -o -name "*.yaml" -o -name "*.yml" -o -name "*.toml" -o \
        -name "credentials" -o -name "credentials.*" -o \
        -name "auth"        -o -name "auth.*"        -o \
        -name "token"       -o -name "token.*"       -o \
        -name "config"      -o -name "config.*"      \
    \) 2>/dev/null | while IFS= read -r f; do
        rel="${f#$INSTALL_DIR/}"
        mkdir -p "$CREDS_BACKUP/$(dirname "$rel")"
        cp "$f" "$CREDS_BACKUP/$rel"
    done
}

restore_login_data() {
    if [ -n "$(ls -A "$CREDS_BACKUP" 2>/dev/null)" ]; then
        echo "Restoring login data..."
        mkdir -p "$INSTALL_DIR"
        cp -rn "$CREDS_BACKUP/." "$INSTALL_DIR/"
    fi
}

# -------------------------------------------------------
# 5. Remove any existing installation (beta or stable)
# -------------------------------------------------------
echo "Removing existing installation (if any)..."

# Homebrew: remove beta tap and stable tap
if command -v brew &>/dev/null; then
    brew unlink pandev-cli-plugin 2>/dev/null || true
    brew uninstall pandev-metriks/pandev-cli-beta/pandev-cli-plugin 2>/dev/null || true
    brew untap "$BETA_TAP" 2>/dev/null || true
    brew uninstall pandev-metriks/pandev-cli/pandev-cli-plugin 2>/dev/null || true
    brew untap pandev-metriks/pandev-cli 2>/dev/null || true
fi

# Direct install: remove binaries and install dir
save_login_data
rm -f "$BIN_LINK" "$BIN_DIR/pandev-cli-plugin"
rm -rf "$INSTALL_DIR"

echo "Cleanup complete."

# -------------------------------------------------------
# 6. Install
# -------------------------------------------------------
install_direct() {
    echo "Using direct GitHub release installation."
    echo "Version: $VERSION"

    ASSET="pandev-cli-plugin_${VERSION}_${OS_NAME}_${ARCH_NAME}.tar.gz"
    DOWNLOAD_URL="https://github.com/$REPO/releases/download/v${VERSION}/$ASSET"

    TMP_DIR=$(mktemp -d)

    echo "Downloading $ASSET..."
    curl -fsSL --retry 5 --retry-delay 3 --connect-timeout 30 --max-time 600 \
         "$DOWNLOAD_URL" -o "$TMP_DIR/$ASSET"

    echo "Extracting..."
    mkdir -p "$INSTALL_DIR"
    tar -xzf "$TMP_DIR/$ASSET" -C "$INSTALL_DIR"

    chmod +x "$INSTALL_DIR/bin/pandev" "$INSTALL_DIR/bin/pandev-cli-plugin"

    mkdir -p "$BIN_DIR"
    ln -sf "$INSTALL_DIR/bin/pandev" "$BIN_LINK"
    ln -sf "$INSTALL_DIR/bin/pandev-cli-plugin" "$BIN_DIR/pandev-cli-plugin"
}

brew_install_with_retry() {
    local attempts=3
    local i=1
    while [ "$i" -le "$attempts" ]; do
        echo "Homebrew install attempt $i/$attempts..."
        if brew install "$FORMULA"; then
            return 0
        fi
        if [ "$i" -lt "$attempts" ]; then
            echo "Attempt $i failed, retrying in 5s..."
            sleep 5
        fi
        i=$((i + 1))
    done
    return 1
}

if [[ "$OS" == "Darwin" ]] && command -v brew &>/dev/null; then
    echo "Homebrew detected: $(brew --version | head -1)"
    if brew_install_with_retry; then
        echo "Homebrew install succeeded."
    else
        echo "Homebrew install failed after retries — falling back to direct GitHub release..."
        install_direct
    fi
else
    install_direct
fi

restore_login_data

# -------------------------------------------------------
# 7. Add ~/.local/bin to PATH permanently
# -------------------------------------------------------
detect_profile() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        if [[ "$OS" == "Darwin" ]]; then
            echo "$HOME/.bash_profile"
        else
            echo "$HOME/.bashrc"
        fi
    else
        echo "$HOME/.profile"
    fi
}

PROFILE_FILE=$(detect_profile)

add_path_if_missing() {
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$PROFILE_FILE" 2>/dev/null; then
        echo "" >> "$PROFILE_FILE"
        echo "# pandev-cli" >> "$PROFILE_FILE"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$PROFILE_FILE"
        echo "Added ~/.local/bin to PATH in $PROFILE_FILE"
    fi
}

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    add_path_if_missing
    export PATH="$HOME/.local/bin:$PATH"
fi

# -------------------------------------------------------
# 8. Verify installation
# -------------------------------------------------------
echo ""
echo "Installation complete!"
echo ""

INSTALLED_BIN=""
if command -v pandev &>/dev/null; then
    INSTALLED_BIN=$(command -v pandev)
elif [ -x "$BIN_LINK" ]; then
    INSTALLED_BIN="$BIN_LINK"
fi

if [ -n "$INSTALLED_BIN" ]; then
    INSTALLED_VER=$("$INSTALLED_BIN" -v 2>/dev/null || "$INSTALLED_BIN" --version 2>/dev/null || echo "unknown")
    echo "pandev is ready to use."
    echo "Installed version: $INSTALLED_VER"
    if echo "$INSTALLED_VER" | grep -qF "$VERSION"; then
        echo "Version check: OK (v$VERSION)"
    else
        echo "WARNING: expected v$VERSION but got: $INSTALLED_VER"
        echo "The binary in the GitHub release may have been built with a different version string."
    fi
else
    echo "If command not found, restart your terminal."
fi

echo ""
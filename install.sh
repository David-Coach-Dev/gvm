#!/bin/bash
# GVM Installer Script - Equivalent to NVM for Node.js
# Usage: curl -o- https://raw.githubusercontent.com/David-Coach-Dev/gvm/main/install.sh | bash

set -e

# Configuration
GVM_VERSION=${GVM_VERSION:-latest}
GVM_DIR=${GVM_DIR:-$HOME/.gvm}
GVM_REPO=${GVM_REPO:-David-Coach-Dev/gvm}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art Banner like NVM
echo -e "${CYAN}"
cat << 'EOF'

  ██████╗ ██╗   ██╗███╗   ███╗
 ██╔════╝ ██║   ██║████╗ ████║
 ██║  ███╗██║   ██║██╔████╔██║
 ██║   ██║╚██╗ ██╔╝██║╚██╔╝██║
 ╚██████╔╝ ╚████╔╝ ██║ ╚═╝ ██║
  ╚═════╝   ╚═══╝  ╚═╝     ╚═╝

       Go Version Manager v1.0.0
    https://github.com/David-Coach-Dev/gvm

EOF
echo -e "${NC}"

echo -e "${GREEN}Installing GVM (Go Version Manager)...${NC}"
echo ""

# Function to detect OS and architecture
detect_platform() {
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    local arch=$(uname -m)

    case $os in
        linux*)     OS="linux" ;;
        darwin*)    OS="darwin" ;;
        msys*|cygwin*|mingw*) OS="windows" ;;
        *)          echo -e "${RED}Unsupported OS: $os${NC}"; exit 1 ;;
    esac

    case $arch in
        x86_64|amd64)   ARCH="amd64" ;;
        i386|i686)      ARCH="386" ;;
        arm64|aarch64)  ARCH="arm64" ;;
        arm*)           ARCH="arm" ;;
        *)              echo -e "${RED}Unsupported architecture: $arch${NC}"; exit 1 ;;
    esac

    echo -e "${YELLOW}=> Detected platform: ${OS}/${ARCH}${NC}"
}

# Function to get latest version
get_latest_version() {
    if command -v curl >/dev/null 2>&1; then
        VERSION=$(curl -s "https://api.github.com/repos/${GVM_REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    elif command -v wget >/dev/null 2>&1; then
        VERSION=$(wget -qO- "https://api.github.com/repos/${GVM_REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    else
        echo -e "${YELLOW}   Warning: Could not fetch latest version, using v1.0.0${NC}"
        VERSION="v1.0.0"
    fi

    if [ -z "$VERSION" ]; then
        VERSION="v1.0.0"
    fi

    echo -e "${YELLOW}=> Latest version: ${VERSION}${NC}"
}

# Function to download file
download_file() {
    local url=$1
    local output=$2

    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$output"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$url" -O "$output"
    else
        echo -e "${RED}Error: Neither curl nor wget is available${NC}"
        return 1
    fi
}

# Function to install GVM
install_gvm() {
    echo -e "${YELLOW}=> Creating directory structure...${NC}"

    # Create directories
    mkdir -p "$GVM_DIR/bin"
    mkdir -p "$GVM_DIR/versions"
    mkdir -p "$GVM_DIR/temp"
    echo "   Created: $GVM_DIR"

    # Determine version to install
    if [ "$GVM_VERSION" = "latest" ]; then
        echo -e "${YELLOW}=> Fetching latest version...${NC}"
        get_latest_version
        GVM_VERSION=$VERSION
    fi

    echo -e "${YELLOW}=> Downloading GVM ${GVM_VERSION}...${NC}"

    # Determine binary name based on OS
    local binary_name="gvm"
    if [ "$OS" = "windows" ]; then
        binary_name="gvm.exe"
    fi

    # Download GVM binary
    local gvm_url="https://github.com/${GVM_REPO}/releases/download/${GVM_VERSION}/gvm-${OS}-${ARCH}"
    if [ "$OS" = "windows" ]; then
        gvm_url="https://github.com/${GVM_REPO}/releases/download/${GVM_VERSION}/gvm.exe"
    fi

    local gvm_path="$GVM_DIR/bin/$binary_name"

    # Try to download
    if download_file "$gvm_url" "$gvm_path"; then
        echo "   Downloaded: $gvm_path"
    else
        # Try fallback URLs
        echo -e "${YELLOW}   Trying fallback URLs...${NC}"
        local fallback_urls=(
            "https://github.com/${GVM_REPO}/releases/latest/download/gvm-${OS}-${ARCH}"
            "https://raw.githubusercontent.com/${GVM_REPO}/main/gvm"
        )

        local downloaded=false
        for url in "${fallback_urls[@]}"; do
            echo "   Trying: $url"
            if download_file "$url" "$gvm_path"; then
                downloaded=true
                break
            fi
        done

        if [ "$downloaded" = false ]; then
            echo -e "${RED}Error: Could not download GVM binary from any source${NC}"
            exit 1
        fi
    fi

    # Make executable
    chmod +x "$gvm_path"
    echo -e "${GREEN}   Made executable: $gvm_path${NC}"

    # Verify the binary works
    if "$gvm_path" --version >/dev/null 2>&1; then
        echo -e "${GREEN}   Verified: GVM is working${NC}"
    else
        echo -e "${YELLOW}   Warning: Could not verify GVM binary${NC}"
    fi
}

# Function to configure shell integration
configure_shell() {
    echo -e "${YELLOW}=> Configuring shell integration...${NC}"

    # Detect shell
    local shell_name=$(basename "$SHELL")
    local profile_file=""

    case $shell_name in
        bash)
            if [ -f "$HOME/.bashrc" ]; then
                profile_file="$HOME/.bashrc"
            elif [ -f "$HOME/.bash_profile" ]; then
                profile_file="$HOME/.bash_profile"
            else
                profile_file="$HOME/.bashrc"
                touch "$profile_file"
            fi
            ;;
        zsh)
            profile_file="$HOME/.zshrc"
            ;;
        fish)
            profile_file="$HOME/.config/fish/config.fish"
            mkdir -p "$(dirname "$profile_file")"
            ;;
        *)
            profile_file="$HOME/.profile"
            ;;
    esac

    # Create GVM initialization script
    local gvm_init='
# GVM (Go Version Manager) integration
export GVM_DIR="'$GVM_DIR'"
[ -s "$GVM_DIR/bin/gvm" ] && export PATH="$GVM_DIR/bin:$PATH"

# Optional: Auto-switch Go version based on .go-version file
gvm_auto_switch() {
    if [ -f ".go-version" ]; then
        local version=$(cat .go-version | head -n1 | tr -d "[:space:]")
        if [ -n "$version" ]; then
            gvm use "$version" 2>/dev/null || true
        fi
    fi
}

# Uncomment the next line to enable auto-switching
# cd() { builtin cd "$@" && gvm_auto_switch; }
'

    # Add to profile file
    if ! grep -q "GVM (Go Version Manager)" "$profile_file" 2>/dev/null; then
        echo "$gvm_init" >> "$profile_file"
        echo -e "${GREEN}   Added GVM to $profile_file${NC}"
    else
        echo -e "${YELLOW}   GVM already in $profile_file${NC}"
    fi

    # Special handling for fish shell
    if [ "$shell_name" = "fish" ]; then
        local fish_config='
# GVM (Go Version Manager) integration
set -gx GVM_DIR "'$GVM_DIR'"
if test -s "$GVM_DIR/bin/gvm"
    set -gx PATH $GVM_DIR/bin $PATH
end
'
        if ! grep -q "GVM (Go Version Manager)" "$profile_file" 2>/dev/null; then
            echo "$fish_config" >> "$profile_file"
            echo -e "${GREEN}   Added GVM to Fish config${NC}"
        fi
    fi
}

# Function to show completion message
show_completion() {
    echo ""
    echo -e "${GREEN}=> GVM installation completed!${NC}"
    echo ""
    echo -e "${CYAN}To get started:${NC}"
    echo -e "   1. Close and reopen your terminal (or run: source ~/.bashrc)"
    echo -e "   2. Run: gvm install 1.21.0"
    echo -e "   3. Run: gvm use 1.21.0"
    echo ""
    echo -e "${CYAN}Commands:${NC}"
    echo -e "   gvm install <version>    Install a Go version"
    echo -e "   gvm use <version>        Switch to a Go version"
    echo -e "   gvm list                 List installed versions"
    echo -e "   gvm list-remote          List available versions"
    echo -e "   gvm uninstall <version>  Remove a Go version"
    echo ""
    echo -e "${CYAN}Documentation: https://github.com/${GVM_REPO}${NC}"
    echo ""
    echo -e "${GREEN}Happy coding! 🚀${NC}"
}

# Main execution
main() {
    detect_platform
    install_gvm
    configure_shell
    show_completion

    echo ""
    echo -e "${GREEN}Installation successful! ✨${NC}"
    echo ""
    echo -e "${YELLOW}Run 'source ~/.bashrc' or restart your terminal to start using GVM${NC}"
}

# Run main function
main "$@"

#!/bin/bash
# Install zmx (terminal multiplexer) from source
# Requires: curl, tar, git

set -e

ZIG_VERSION="0.15.2"
ZMX_REPO="https://github.com/neurosnap/zmx"

echo "=== Installing zmx ==="

# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download and extract Zig
echo "Downloading Zig ${ZIG_VERSION}..."
curl -sL "https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz" | tar xJ
ZIG="$TEMP_DIR/zig-linux-x86_64-${ZIG_VERSION}/zig"

# Clone zmx
echo "Cloning zmx..."
git clone --depth 1 "$ZMX_REPO" zmx
cd zmx

# Build zmx
echo "Building zmx..."
"$ZIG" build -Doptimize=ReleaseSafe --prefix ~/.local

# Install globally
echo "Installing zmx to /usr/local/bin..."
sudo cp ~/.local/bin/zmx /usr/local/bin/

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo "=== zmx installed successfully ==="
zmx --version

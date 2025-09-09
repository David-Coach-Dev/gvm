#!/bin/bash
# Simple build script for GVM

set -e

echo "Building GVM..."

# Build for current platform
go build -ldflags="-s -w" -o gvm main.go

if [ $? -eq 0 ]; then
    echo "✅ Build successful: gvm"

    # Test the binary
    if ./gvm --version >/dev/null 2>&1; then
        version=$(./gvm --version)
        echo "✅ Binary test passed: $version"
    else
        echo "⚠️  Warning: Binary test failed"
    fi
else
    echo "❌ Build failed"
    exit 1
fi

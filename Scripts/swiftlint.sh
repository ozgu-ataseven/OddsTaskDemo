#!/bin/bash

# SwiftLint Build Phase Script for OddsTask
# This script runs SwiftLint during the build process

# Add Homebrew path for SwiftLint
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"

# Check if SwiftLint is installed
if which swiftlint >/dev/null; then
    echo "SwiftLint found, running..."
    swiftlint
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
    exit 0
fi

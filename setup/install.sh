#!/bin/bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/bfpimentel/dotfiles.git"

if ! command -v git &>/dev/null; then
    echo "Error: git is not installed. Please install git first."
    exit 1
fi

echo "Cloning dotfiles..."

if [ -d "$DOTFILES_DIR" ]; then
    echo "Directory $DOTFILES_DIR already exists. Skipping clone."
else
    git clone "$REPO_URL" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR/setup"

echo "Running initialization script..."

if [ -f "init.sh" ]; then
    chmod +x init.sh
    ./init.sh
else
    echo "Error: init.sh not found in $DOTFILES_DIR/setup"
    exit 1
fi

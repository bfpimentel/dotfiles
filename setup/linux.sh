#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if ! command_exists yay; then
  echo "Installing yay..."
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  echo "yay is already installed."
fi

packages=(
  "antidote"
  "tmux"
  "tpm"
  "stow"
  "pnpm"
  "uv"
  "overmind"
  "direnv"
  "lua"
  "lazygit"
  "gnupg"
  "ripgrep"
  "libpcap"
  "xz"
  "xh"
  "fzf"
  "wget"
  "opencode"
  "podman"
  "podman-compose"
  "tree-sitter"
  "ruff"
  "emmylua_ls"
  "stylua"
  "bash-language-server"
  "shfmt"
  "yaml-language-server"
  "yamlfmt"
  "typescript-language-server"
  "tailwindcss-language-server"
  "vscode-langservers-extracted"
)

echo "Installing packages..."

for package in "${packages[@]}"; do
  if pacman -Si "$package" &>/dev/null; then
    echo "Installing $package with pacman..."
    sudo pacman -S --needed --noconfirm "$package"
  else
    echo "Package $package not found in official repositories. Trying yay..."
    yay -S --needed --noconfirm "$package"
  fi
done

echo "Linux setup complete."

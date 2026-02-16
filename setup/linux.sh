#!/bin/bash

install_yay() {
  if ! command -v yay &>/dev/null; then
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
  fi
}

execute "Checking/Installing Yay" install_yay

install_package() {
  local package="$1"
  if pacman -Si "$package" &>/dev/null; then
    sudo pacman -S --needed --noconfirm "$package"
  else
    yay -S --needed --noconfirm "$package"
  fi
}

packages=(
  "zsh"
  "zinit"
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
  "tree-sitter-cli"
  "ruff"
  "emmylua-ls-bin"
  "stylua"
  "bash-language-server"
  "shfmt"
  "yaml-language-server"
  "yamlfmt"
  "typescript-language-server"
  "tailwindcss-language-server"
  "vscode-langservers-extracted"
)

for package in "${packages[@]}"; do
  execute "Installing $package" "install_package $package"
done

set_default_shell() {
  local zsh_path=$(which zsh)
  if [ "$SHELL" != "$zsh_path" ]; then
    sudo chsh -s "$zsh_path" "$USER"
  fi
}

execute "Setting Zsh as Default Shell" set_default_shell

echo "Linux setup complete."

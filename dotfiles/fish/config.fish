# Global Env Variables
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx TMUXDIR "$HOME/.config/tmux"
set -gx TMPDIR "/tmp"

set -gx VISUAL "nvim"
set -gx EDITOR "$VISUAL"
set -gx MANPAGE "nvim +Man!"

set -gx DOCKER_HOST "unix:///tmp/podman/podman-machine-default-api.sock"

# MacOS specific
set -gx BREWPREFIX "/opt/homebrew"

# Path
set -ga fish_user_paths "$HOME/.local/bin"
set -ga fish_user_paths "$HOME/.nix-profile/bin"
set -ga fish_user_paths "$BREWPREFIX/bin"
set -ga fish_user_paths "$BREWPREFIX/sbin"

# Options
set -g fish_greeting

# Aliases
alias gst "lazygit"
alias visudo "sudo -E visudo"

alias cc "cd ~/.dotfiles"
alias ec "cd ~/.dotfiles && nvim ."

alias os "nh os switch ~/.dotfiles"
alias hm "nh home switch ~/.dotfiles --impure"

if test (uname) = "Darwin"
    eval "$(brew shellenv)"
end

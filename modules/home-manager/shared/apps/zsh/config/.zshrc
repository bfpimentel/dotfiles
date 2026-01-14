# Options
setopt extended_glob null_glob
setopt append_history share_history inc_append_history
setopt hist_ignore_dups hist_ignore_space

# Env
export TERM="xterm-256color"
export XDG_CONFIG_HOME="$HOME/.config"

export LANG="en_US.UTF-8"
export VISUAL="nvim"
export EDITOR="$VISUAL"
export MANPAGER="nvim +Man!"

export ANDROID_HOME="$HOME/Library/Android/sdk"

export NIX_PATH="nixpkgs=flake:nixpkgs"

if [ -f "$ZDOTDIR/.secrets" ]; then
  source "$ZDOTDIR/.secrets"
fi

# Path
path=(
    $path
    /run/wrappers/bin
    /run/current-system/sw/bin
    $HOME/.nix-profile/bin
    /etc/profiles/per-user/$USER/bin
    $ANDROID_HOME/tools
    $ANDROID_HOME/platform-tools
)

# Darwin specific paths
if [[ "$OSTYPE" == darwin* ]]; then
    path+=(
        /opt/homebrew/bin
        /opt/homebrew/opt/ruby/bin
        /opt/homebrew/opt/postgresql@17/bin
        # /Applications/Postgres.app/Contents/Versions/latest/bin
        $HOME/.cache/npm/global/bin
    )
fi

typeset -U path
path=($^path(N-/))

export PATH

# Antidote
antidote load $ZDOTDIR/.zsh_plugins.txt

# History
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="${HOME}/.zsh_history"

# Prompt
fpath+=($ZDOTDIR/plugins)
autoload -Uz prompt_bfmp; prompt_bfmp
autoload -Uz colors; colors
autoload -Uz compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Edit command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Aliases
alias szsh="source $ZDOTDIR/.zshrc"

alias vim="nvim"
alias gst="lazygit"
alias visudo="sudo -E visudo"

alias cdnix="cd /etc/nixos"
alias cnix="nvim /etc/nixos"
alias cnvim="nvim ~/.config/nvim"
alias czsh="nvim ~/.config/zsh"

if [[ "$OSTYPE" == darwin* ]]; then
   eval "$(direnv hook zsh)"

   alias rnix="nh darwin switch --impure /private/etc/nixos"

   hnix() {
     nix run "github:NixOS/nixpkgs#nixos-rebuild" -- switch --fast --use-remote-sudo --target-host bruno@malenia --flake /etc/nixos#malenia
     nix run "github:NixOS/nixpkgs#nixos-rebuild" -- switch --fast --use-remote-sudo --target-host bruno@miquella --flake /etc/nixos#miquella
   }

   adbw() {
     adb connect "$1":"$2"
     adb tcpip 5555
     adb disconnect
     adb connect "$1":5555
   }
else
    alias rnix="nh os switch /etc/nixos -- --impure"
fi

source <(fzf --zsh)

# if command -v zellij &> /dev/null && [ -z "$ZELLIJ" ]; then
#   zellij attach bruno
# fi

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default
fi

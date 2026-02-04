# Options
setopt extended_glob null_glob
setopt append_history share_history inc_append_history
setopt hist_ignore_dups hist_ignore_space

# Env
export TERM="xterm-256color"
export XDG_CONFIG_HOME="$HOME/.config"
export TMUXDIR="$HOME/.config/tmux"

export LANG="en_US.UTF-8"
export VISUAL="nvim"
export EDITOR="$VISUAL"
export MANPAGER="nvim +Man!"
export TMPDIR="/tmp"

export ANDROID_HOME="$HOME/Library/Android/sdk"

export DOCKER_HOST='unix:///tmp/podman/podman-machine-default-api.sock'

if [ -f "$ZDOTDIR/.secrets" ]; then
  source "$ZDOTDIR/.secrets"
fi

# Path
path=(
    $path
    $HOME/.local/bin
    $HOME/.bun/bin
    $HOME/.cache/npm/global/bin
    $ANDROID_HOME/tools
    $ANDROID_HOME/platform-tools
    $(brew --prefix)/bin
    $(brew --prefix)/opt/postgresql@17/bin
)

typeset -U path
path=($^path(N-/))

export PATH

# Antidote
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
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

alias gst="lazygit"
alias visudo="sudo -E visudo"

alias cc="cd ~/.config && nvim ."

adbw() {
 adb connect "$1":"$2"
 adb tcpip 5555
 adb disconnect
 adb connect "$1":5555
}

source <(fzf --zsh)

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default
fi

# vim: set ft=zsh :

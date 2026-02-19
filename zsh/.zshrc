# Env
export TERM="xterm-256color"

export XDG_CONFIG_HOME="$HOME/.config"
export TMUXDIR="$HOME/.config/tmux"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export LANG="en_US.UTF-8"
export VISUAL="nvim"
export EDITOR="$VISUAL"
export MANPAGER="nvim +Man!"
export TMPDIR="/tmp"

export ANDROID_HOME="$HOME/Library/Android/sdk"

export DOCKER_HOST='unix:///tmp/podman/podman-machine-default-api.sock'

export LS_COLORS="di=34:ln=36:so=35:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;34"

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
)

if [[ "$OSTYPE" == "darwin"* ]]; then
  export BREWPREFIX=$(brew --prefix)

  path+=(
    $BREWPREFIX/bin
    $BREWPREFIX/sbin
    $BREWPREFIX/opt/postgresql@17/bin
    $BREWPREFIX/opt/qt/bin
  )
else
  path+=()
fi

typeset -U path
path=($^path(N-/))

export PATH

# Zinit
if [[ "$OSTYPE" == "darwin"* ]]; then
  source $BREWPREFIX/opt/zinit/zinit.zsh
  eval "$(brew shellenv)"
else
  source /usr/share/zinit/zinit.zsh
fi

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit snippet "$ZDOTDIR/plugins/bfmp.zsh"
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# Edit command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# History
HISTSIZE=1000000
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color --group-directories-first $realpath '

# Aliases
alias szsh="source $ZDOTDIR/.zshrc"

alias gst="lazygit"
alias visudo="sudo -E visudo"

alias cc="cd ~/.dotfiles"
alias ec="cd ~/.dotfiles && nvim ."

alias ls="eza -l --color --group-directories-first"

adbw() {
 adb connect "$1":"$2"
 adb tcpip 5555
 adb disconnect
 adb connect "$1":5555
}

# Tools
eval "$(fzf --zsh)"

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Init
if [[ "$OSTYPE" == "darwin"* ]] && command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default
fi

# vim: set ft=zsh :

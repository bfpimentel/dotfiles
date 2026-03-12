# Env
export TERM="xterm-256color"

export LANG="en_US.UTF-8"

export XDG_CONFIG_HOME="$HOME/.config"
export TMUXDIR="$HOME/.config/tmux"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export TMPDIR="/tmp"

export VISUAL="nvim"
export EDITOR="$VISUAL"
export MANPAGER="nvim +Man!"

export DOCKER_HOST='unix:///tmp/podman/podman-machine-default-api.sock'

export LS_COLORS="di=34:ln=36:so=35:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;34"

if [ -f "$ZDOTDIR/.secrets" ]; then
    source "$ZDOTDIR/.secrets"
fi

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.nix-profile/bin"

if [[ "$OSTYPE" == "darwin"* ]]; then
    export CHROME_EXECUTABLE="/Applications/Helium.app/Contents/MacOS/Helium"

    export BREWPREFIX="$(brew --prefix)"
    export PATH="$PATH:$BREWPREFIX/bin"
    export PATH="$PATH:$BREWPREFIX/sbin"

    eval "$(brew shellenv)"
fi

zplug zsh-users/zsh-syntax-highlighting
zplug zsh-users/zsh-autosuggestions
zplug zsh-users/zsh-completions
zplug Aloxaf/fzf-tab

zplug load

# Load completions
autoload -Uz compinit && compinit

# Prompt
source "$ZDOTDIR/plugins/bfmp.zsh"

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
HISTDUP=erase
HISTSIZE=1000000
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE

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
eval "$(direnv hook zsh)"

[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Tmux
if [[ "$OSTYPE" == "darwin"* ]] && command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach-session -t default
fi

# vim: set ft=zsh :

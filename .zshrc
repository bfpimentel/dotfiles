if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="/home/bruno/.config/zsh/"
export TERM="xterm-256color"
export EDITOR="nvim"
export QMK_HOME="$HOME/.qmk"
export VISUAL=$EDITOR
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.flutter-sdk/bin:$PATH"

ZSH_THEME="powerlevel10k/powerlevel10k"

source $ZSH/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle pip
antigen bundle command-not-found
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme romkatv/powerlevel10k

antigen apply

# git aliases
alias gst="git status -sb"
alias gc="git commit"

# dotfile git aliases
alias config="/usr/bin/git --git-dir=$HOME/.config/ --work-tree=$HOME"
alias cst="config status -sb"
alias cf="config fetch"
alias ca="config add"
alias cc="config commit"
alias cpom="config push origin master"

# vim
alias vim="nvim"

# python
alias py="python3"
alias pip="python3 -m pip"

# p10k init
[[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh

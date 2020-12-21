export ZSH="/home/bruno/.oh-my-zsh"
export TERM="xterm-256color"
export EDITOR="nvim"
export VISUAL=$EDITOR

ZSH_THEME="robbyrussell"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# git aliases
alias gst="git status -sb"
alias gc="git commit"

# dotfile git aliases
alias config='/usr/bin/git --git-dir=$HOME/.config/ --work-tree=$HOME'
alias cst="config status -sb"
alias cf="config fetch"
alias ca="config add"
alias cc="config commit"

# vim
alias vim="nvim"

# python
alias py="python3"
alias pip="python3 -m pip"

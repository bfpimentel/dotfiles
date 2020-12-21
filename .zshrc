export ZSH="/home/bruno/.oh-my-zsh"

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

# ssh
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa_personal
ssh-add ~/.ssh/id_rsa_work

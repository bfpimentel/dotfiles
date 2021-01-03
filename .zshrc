# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="/home/bruno/.config/zsh/"
export TERM="xterm-256color"
export EDITOR="nvim"
export PATH="$HOME/.local/bin:$PATH"
export QMK_HOME="$HOME/.qmk"
export VISUAL=$EDITOR

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh

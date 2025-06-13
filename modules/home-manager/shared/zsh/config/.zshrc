export TERM="xterm-256color"
export ZSH="$HOME/.config/zsh"

export LANG="en_US.UTF-8"
export VISUAL="nvim"
export EDITOR="$VISUAL"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export AE_DEPLOYMENT_ENV="debug"
export MANPAGER="nvim +Man!"

export PATH="$PATH:/run/wrappers/bin"
export PATH="$PATH:/run/current-system/sw/bin"
export PATH="$PATH:$HOME/.nix-profile/bin"
export PATH="$PATH:/etc/profiles/per-user/$USER/bin"
export PATH="$PATH:/opt/homebrew/opt/ruby/bin"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

autoload -U compinit && compinit
autoload -U colors && colors

# Antigen
antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# Aliases
alias vim="nvim"
alias gst="lazygit"
alias cnix="nvim /etc/nixos"
alias cdnix="cd /etc/nixos"
alias cn="vim ~/.config/nvim"
alias cz="vim ~/.config/zsh"
alias visudo="sudo -E visudo"

# History
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="${HOME}/.zsh_history"
HISTCONTROL=ignoreboth # consecutive duplicates & commands starting with space are not saved

setopt append_history share_history inc_append_history
setopt auto_menu menu_complete    # autocmp first menu match
setopt autocd                     # type a dir to cd
setopt auto_param_slash           # when a dir is completed, add a / instead of a trailing space
setopt no_case_glob no_case_match # make cmp case insensitive
setopt globdots                   # include dotfiles
setopt extended_glob              # match ~ # ^
setopt interactive_comments       # allow comments in shell
unsetopt prompt_sp                # don't autoclean blanklines

zstyle ":completion:*" menu select
zstyle ":completion:*" file-list true
zstyle ":completion:*" squeeze-slashes false # explicit disable to allow /*/ expansion
# shellcheck disable=SC2296
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}" ma=0\;33 # colorize cmp menu

autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_update_prompt
add-zsh-hook precmd precmd_update_git_vars
add-zsh-hook preexec preexec_update_git_vars

function chpwd_update_prompt() {
    NEWLINE=$'\n'
    PROMPT="${NEWLINE}%K{}%F{#d5c4a1} zsh %K{#1d2021}%F{#d5c4a1} %n %K{#282828}%F{#d5c4a1} %~ "

    local_branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    git_status=$?
    if [ $git_status -eq 0 ] && [ -n "$local_branch_name" ]; then
        PROMPT="${PROMPT}(git: ${local_branch_name}) "
    fi

    PROMPT="${PROMPT}${NEWLINE}%k%f "
}

function precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ -z "$ZSH_THEME_GIT_PROMPT_CACHE" ]; then
        chpwd_update_prompt
        unset __EXECUTED_GIT_COMMAND
    fi
}

function preexec_update_git_vars() {
    case "$2" in
    git* | hub* | gh* | stg*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}

# shellcheck source=/dev/null
source <(fzf --zsh)

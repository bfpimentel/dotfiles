update_prompt() {
    local NEWLINE=$'\n'

    local top_left=
    local bottom_left="%F{#D3C6AA}$ %f"
    local top_right=""

    if [ -n "$SSH_TTY" ]; then
        top_left="%F{#7FBBB3}[󰢹  %m]"
    else
        top_left="%F{#83C092}[󰌢  %m]"
    fi

    top_left="${top_left} %F{#DBBC7F}[  %1~]"

    local local_branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$local_branch_name" ]; then
        top_left="${top_left} %F{#E69875}[  ${local_branch_name}]"
    fi

    PROMPT=$top_left${NEWLINE}$bottom_left
}

precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ -z "$ZSH_THEME_GIT_PROMPT_CACHE" ]; then
        update_prompt
        unset __EXECUTED_GIT_COMMAND
    fi
}

preexec_update_git_vars() {
    case "$2" in
        git* | hub* | gh* | stg*)
            __EXECUTED_GIT_COMMAND=1
            ;;
    esac
}

bfmp() {
    autoload -U add-zsh-hook
    add-zsh-hook chpwd update_prompt
    add-zsh-hook precmd precmd_update_git_vars
    add-zsh-hook preexec preexec_update_git_vars
}

bfmp

# vim: set ft=zsh :

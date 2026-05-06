bindkey -v

function _zsh_set_cursor() {
    [[ -t 1 ]] || return

    case "$KEYMAP" in
        vicmd) print -n -- $'\e[2 q' ;;
        *) print -n -- $'\e[6 q' ;;
    esac
}

function zle-keymap-select() {
    _zsh_set_cursor
}

function zle-line-init() {
    _zsh_set_cursor
}

function zle-line-finish() {
    print -n -- $'\e[2 q'
}

zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

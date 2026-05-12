export TMPDIR="/tmp"
export TMUXDIR="$XDG_CONFIG_HOME/tmux"

export VISUAL="nvim"
export EDITOR="$VISUAL"
export MANPAGE="nvim +Man!"

export DOCKER_HOST="unix:///tmp/podman/podman-machine-default-api.sock"

typeset -gU path PATH
path=(
    "$HOME/.local/bin"
    "$HOME/.nix-profile/bin"
    $path
)

if [[ "$(uname -s)" == "Darwin" ]]; then
    path=(
        "$HOME/.lmstudio/bin"
        $path
    )
fi

function deploy() {
    local repo="${DOTFILES:-$HOME/.dotfiles}"
    local targets
    local host

    if (( $# > 0 )); then
        targets=("$@")
    else
        targets=(cherubim powers thronos)
    fi

    for host in "${targets[@]}"; do
        case "$host" in
            cherubim|powers|thronos) ;;
            *)
                print -u2 "unknown deploy target: $host"
                print -u2 "valid targets: cherubim powers thronos"
                return 1
                ;;
        esac
    done

    for host in "${targets[@]}"; do
        print "deploying $host"

        nix run nixpkgs#nixos-rebuild -- switch \
            --flake "$repo#$host" \
            --target-host "$host" \
            --build-host "$host" \
            --sudo \
            --ask-sudo-password

        if [[ "$?" -ne 0 ]]; then
            print -u2 "deploy failed: $host"
            return 1
        fi
    done
}

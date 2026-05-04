function deploy() {
    local repo="${DOTFILES:-$HOME/.dotfiles}"
    local targets
    local host
    local current_step=""
    local current_state=""
    local -A deploy_hosts

    function deploy_banner() {
        cat <<'EOF'
########################################
#  ┏┓╻╻╻ ╻┏━┓┏━┓   ╺┳┓┏━╸┏━┓╻  ┏━┓╻ ╻  #
#  ┃┗┫┃┏╋┛┃ ┃┗━┓    ┃┃┣╸ ┣━┛┃  ┃ ┃┗┳┛  #
#  ╹ ╹╹╹ ╹┗━┛┗━┛   ╺┻┛┗━╸╹  ┗━╸┗━┛ ╹   #
########################################
EOF
        print "remote nix deployment"
        print "repo: $repo"
        print "targets: ${targets[*]}"
    }

    function deploy_render() {
        local item
        local marker
        local state

        [[ -t 1 ]] && clear
        deploy_banner

        print ""
        print "status"

        for item in "${targets[@]}"; do
            state="${deploy_hosts[$item]:-pending}"

            case "$state" in
                running) marker=">>" ;;
                done) marker="ok" ;;
                failed) marker="!!" ;;
                *) marker=".." ;;
            esac

            print -r -- "[$marker] $item"
        done

        if [[ -n "$current_step" ]]; then
            print ""
            print -r -- "current: [$current_state] $host :: $current_step"
        fi
    }

    function deploy_step() {
        local label="$1"
        local state="$2"

        current_step="$label"
        current_state="$state"
        deploy_render
    }

    function deploy_run_quiet() {
        local label="$1"
        local log
        shift

        log="$(mktemp -t "deploy-${host}-${label//[^A-Za-z0-9]/-}.XXXXXX")"

        "$@" >"$log" 2>&1

        if [[ "$?" -ne 0 ]]; then
            deploy_hosts[$host]="failed"
            deploy_step "$label" "failed"
            print -u2 ""
            print -u2 "---- $host :: $label log ----"
            cat "$log" >&2
            print -u2 "---- end log ----"
            rm -f "$log"
            return 1
        fi

        rm -f "$log"
        deploy_step "$label" "ok"
        return 0
    }

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
        deploy_hosts[$host]="pending"
    done

    deploy_render

    for host in "${targets[@]}"; do
        deploy_hosts[$host]="running"
        deploy_step "sync dotfiles" "running"

        deploy_run_quiet "prepare remote" ssh "$host" "mkdir -p ~/.dotfiles" || return 1

        deploy_run_quiet "rsync dotfiles" rsync -az --delete \
            --filter=":- .gitignore" \
            --exclude=".git/" \
            "$repo"/ \
            "$host:~/.dotfiles/" || return 1

        deploy_step "authenticate sudo" "running"

        ssh -t "$host" "sudo -v"

        if [[ "$?" -ne 0 ]]; then
            deploy_hosts[$host]="failed"
            deploy_step "authenticate sudo" "failed"
            return 1
        fi

        deploy_step "authenticate sudo" "ok"
        deploy_step "nixos-rebuild switch" "running"

        deploy_run_quiet "nixos-rebuild switch" nix run nixpkgs#nixos-rebuild -- switch \
            --flake "$repo#$host" \
            --target-host "$host" \
            --build-host "$host" \
            --sudo \
            --ask-sudo-password || return 1

        deploy_hosts[$host]="done"
        deploy_step "complete" "done"
    done

    current_step="all deployments completed"
    current_state="done"
    deploy_render
}

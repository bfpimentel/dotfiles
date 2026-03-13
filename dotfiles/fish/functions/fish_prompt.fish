function fish_prompt
    set -l top_left ""

    if set -q SSH_TTY
        set top_left "$top_left"(set_color 7FBBB3)(prompt_hostname)" [ssh]"
    else
        set top_left "$top_left"(set_color 83C092)(prompt_hostname)
    end

    set -l cwd (basename $PWD)
    if test "$PWD" = "$HOME"
        set cwd "~"
    end
    set top_left "$top_left "(set_color DBBC7F)"$cwd"

    set -l git_branch (git branch --show-current 2>/dev/null)
    if test -n "$git_branch"
        set top_left "$top_left "(set_color E69875)"[$git_branch]"
    end

    if set -q DIRENV_DIR
        set top_left "$top_left "(set_color D699B6)"[dev]"
    end

    echo -e "$top_left"
    echo -e (set_color D3C6AA)"\$ "(set_color normal)
end

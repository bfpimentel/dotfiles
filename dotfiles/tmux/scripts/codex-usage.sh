#!/bin/sh

sessions_dir="${CODEX_HOME:-$HOME/.codex}/sessions"

command -v jq >/dev/null 2>&1 || exit 0
[ -d "$sessions_dir" ] || exit 0

line="$(
  find "$sessions_dir" -type f -name '*.jsonl' -print0 2>/dev/null |
    xargs -0 ls -t 2>/dev/null |
    while IFS= read -r file; do
      grep '"rate_limits"' "$file" 2>/dev/null | tail -n 1
    done |
    sed -n '1p'
)"

[ -n "$line" ] || exit 0

data="$(
  printf '%s\n' "$line" |
    jq -r '
      .payload.rate_limits as $r |
      [
        ($r.plan_type // "codex"),
        ($r.primary.used_percent // empty),
        ($r.primary.resets_at // empty),
        ($r.secondary.used_percent // empty),
        ($r.secondary.resets_at // empty),
        ($r.credits.balance // $r.credits.available_balance // $r.credits.remaining // empty)
      ] | @tsv
    ' 2>/dev/null
)"

[ -n "$data" ] || exit 0

IFS='	' read -r plan primary_used primary_reset secondary_used secondary_reset credits <<EOF
$data
EOF

fmt_reset() {
    reset_at="$1"
    [ -n "$reset_at" ] || return

    now="$(date +%s)"
    remaining=$((reset_at - now))
    [ "$remaining" -gt 0 ] || {
        printf 'now'
        return
    }

    hours=$((remaining / 3600))
    minutes=$(((remaining % 3600 + 59) / 60))

    if [ "$hours" -gt 0 ]; then
        printf '%dh' "$hours"
    else
        printf '%dm' "$minutes"
    fi
}

fmt_percent() {
    value="$1"
    [ -n "$value" ] || return

    awk -v value="$value" 'BEGIN {
    used = int(value + 0.5)
    if (used < 0) used = 0
    if (used > 100) used = 100
    used = 100 - used
    printf "%d%%", used
  }'
}

primary="$(fmt_percent "$primary_used")"
secondary="$(fmt_percent "$secondary_used")"
primary_time="$(fmt_reset "$primary_reset")"
secondary_time="$(fmt_reset "$secondary_reset")"

[ -n "$primary" ] || exit 0

printf '󰅨  Codex [5h: %s' "$primary"
[ -n "$primary_time" ] && printf '/%s] ' "$primary_time"
[ -n "$secondary" ] && printf '[Week: %s' "$secondary"
[ -n "$secondary_time" ] && printf '/%s]' "$secondary_time"
[ -n "$credits" ] && printf ' cr:%s' "$credits"
exit 0

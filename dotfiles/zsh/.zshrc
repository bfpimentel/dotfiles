
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

for file in $ZDOTDIR/conf.d/*.zsh(N); do
    source "$file"
done

autoload -Uz compinit
zmodload zsh/complist

_zsh_cache_dir="$HOME/.cache/zsh"
[[ -d "$_zsh_cache_dir" ]] || mkdir -p "$_zsh_cache_dir"
compinit -d "$_zsh_cache_dir/.zcompdump-$ZSH_VERSION"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{#859289}%d%f'
zstyle ':completion:*:messages' format '%F{#859289}%d%f'
zstyle ':completion:*:warnings' format '%F{#e67e80}no matches found%f'

bindkey '^[[Z' reverse-menu-complete

zsh_plugins_root="$ZDOTDIR/.zsh_plugins"
zsh_plugins_txt="${zsh_plugins_root}.txt"
zsh_plugins_bundle="${zsh_plugins_root}.zsh"
oh_my_posh_bin="$(command -v oh-my-posh)"
antidote_zsh=""

for profile in "$HOME/.local" "$HOME/.nix-profile" "/etc/profiles/per-user/$USER" "/run/current-system/sw"; do
    if [[ -r "$profile/share/antidote/antidote.zsh" ]]; then
        antidote_zsh="$profile/share/antidote/antidote.zsh"
        break
    fi
done

if [[ -n "$antidote_zsh" ]]; then
    source "$antidote_zsh"
else
    print -u2 "zsh: antidote.zsh not found in Nix profiles"
fi

if [[ -n "$antidote_zsh" && -r "$zsh_plugins_txt" ]]; then
    if [[ ! -r "$zsh_plugins_bundle" || "$zsh_plugins_txt" -nt "$zsh_plugins_bundle" ]]; then
        antidote bundle < "$zsh_plugins_txt" >| "$zsh_plugins_bundle"
    fi

    source "$zsh_plugins_bundle"
fi

if [[ -n "$oh_my_posh_bin" ]]; then
    eval "$("$oh_my_posh_bin" init zsh --config "$ZDOTDIR/bfmp.toml")"
else
    print -u2 "zsh: oh-my-posh not found in PATH"
fi

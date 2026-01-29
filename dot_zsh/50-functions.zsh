# Custom shell functions

function tmuxfix() {
  printf '\e[?1000l\e[?1002l\e[?1003l\e[?1006l\e[?1015l'
  stty sane
  tmux source-file ~/.tmux.conf >/dev/null 2>&1 || true
}

function code() {
  local vscode_ipc=$(tmux show-env VSCODE_IPC_HOOK_CLI | cut -d '=' -f2) 2>/dev/null
  if [[ -v TMUX && vscode_ipc != "" ]]; then
    VSCODE_IPC_HOOK_CLI=$vscode_ipc command code "$@"
  else
    command code "$@"
  fi
}

function hgrep() {
    if [ -z "$1" ]; then
        echo "Usage: hgrep [search_term]"
        return 1
    fi
    fc -l -n 1 | grep --color=auto -i "$@" | sed 's/\\n/\n/g;G'
}

function apt() {
    local cmd="$1"

    if [[ -z "$cmd" ]]; then
        apt-fast
        return
    fi

    case "$cmd" in
        install)
            shift
            sudo apt-fast install -y "$@"
            ;;
        update|upgrade|full-upgrade|dist-upgrade|remove|purge|autoremove|clean|autoclean)
            sudo apt-fast "$@"
            ;;
        *)
            apt-fast "$@"
            ;;
    esac
}

function aria2d() {
    if [ -z "$1" ]; then
        echo "Usage: agd <URL> [filename]"
        return 1
    fi

    local url=$1
    local output=$2

    local args=("-s" "16" "-x" "16" "-k" "1M" "--continue=true")

    if [ -n "$output" ]; then
        aria2c "${args[@]}" -o "$output" "$url"
    else
        aria2c "${args[@]}" "$url"
    fi
}

# History synchronization for autosuggestions
autoload -Uz add-zsh-hook
zmodload -F zsh/stat b:zstat 2>/dev/null

typeset -g _HIST_MTIME=0

_sync_hist_for_autosuggest() {
  [[ -o interactive ]] || return

  local -a st
  if zstat -A st +mtime -- "$HISTFILE" 2>/dev/null; then
    (( st[1] == _HIST_MTIME )) && return
    _HIST_MTIME=$st[1]
  fi

  fc -R
}

add-zsh-hook precmd _sync_hist_for_autosuggest

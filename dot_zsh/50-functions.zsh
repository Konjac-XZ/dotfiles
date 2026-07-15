# Custom shell functions

tmuxfix () {
    if [ -t 1 ]; then
        printf '\e[?1000l\e[?1002l\e[?1003l\e[?1006l\e[?1015l'
        printf '\e[?1004l\e[?2004l\e[0m\e[?25h'
    fi

    if [ -t 0 ]; then
        stty sane
    fi

    if typeset -f _zsh_tmux_plugin_run >/dev/null 2>&1; then
        _zsh_tmux_plugin_run source-file "$HOME/.tmux.conf" >/dev/null 2>&1 || true
    elif [ -n "$TMUX" ] && command -v tmux >/dev/null 2>&1; then
        tmux source-file "$HOME/.tmux.conf" >/dev/null 2>&1 || true
    fi

    if [ -n "$TMUX" ] && command -v tmux >/dev/null 2>&1; then
        tmux refresh-client >/dev/null 2>&1 || true
    fi
}

tmuxfix-hard () {
    tmuxfix

    if [ -t 0 ] && [ -t 1 ]; then
        reset
    fi

    if [ -n "$TMUX" ] && command -v tmux >/dev/null 2>&1; then
        tmux source-file "$HOME/.tmux.conf" >/dev/null 2>&1 || true
        tmux refresh-client >/dev/null 2>&1 || true
    fi
}

function code() {
  local vscode_ipc
  local tmux_vscode_ipc
  local vscode_remote_cli
  local vscode_windows_cli="/mnt/c/Users/Konjac-XZ/AppData/Local/Programs/Microsoft VS Code/bin/code"

  if [[ -S "${VSCODE_IPC_HOOK_CLI:-}" ]]; then
    vscode_ipc=$VSCODE_IPC_HOOK_CLI
  elif [[ -n "$TMUX" ]]; then
    tmux_vscode_ipc=$(tmux show-env VSCODE_IPC_HOOK_CLI 2>/dev/null | cut -d '=' -f2)
    [[ -S "$tmux_vscode_ipc" ]] && vscode_ipc=$tmux_vscode_ipc
  fi
  if (( $+commands[code] )); then
    if [[ -n "$vscode_ipc" ]]; then
      VSCODE_IPC_HOOK_CLI=$vscode_ipc command code "$@"
    else
      (unset VSCODE_IPC_HOOK_CLI; command code "$@")
    fi
  elif [[ -x "$vscode_windows_cli" ]]; then
    "$vscode_windows_cli" "$@"
  else
    if command -v fdfind >/dev/null 2>&1; then
      vscode_remote_cli=$(
        fdfind -H -t f --full-path '/bin/remote-cli/code$' "$HOME/.vscode-server" 2>/dev/null \
          | xargs -r stat -c '%Y %n' \
          | sort -nr \
          | awk 'NR == 1 { sub(/^[^ ]+ /, ""); print }'
      )
    elif command -v fd >/dev/null 2>&1; then
      vscode_remote_cli=$(
        fd -H -t f --full-path '/bin/remote-cli/code$' "$HOME/.vscode-server" 2>/dev/null \
          | xargs -r stat -c '%Y %n' \
          | sort -nr \
          | awk 'NR == 1 { sub(/^[^ ]+ /, ""); print }'
      )
    else
      vscode_remote_cli=$(
        find "$HOME/.vscode-server" -path '*/bin/remote-cli/code' -type f -printf '%T@ %p\n' 2>/dev/null \
          | sort -nr \
          | awk 'NR == 1 { sub(/^[^ ]+ /, ""); print }'
      )
    fi

    if [[ -n "$vscode_ipc" && -x "$vscode_remote_cli" ]]; then
      VSCODE_IPC_HOOK_CLI=$vscode_ipc "$vscode_remote_cli" "$@"
    elif [[ -x "$vscode_remote_cli" ]]; then
      env -u VSCODE_IPC_HOOK_CLI "$vscode_remote_cli" "$@"
    else
      print -u2 "code: VS Code launcher not found"
      return 127
    fi
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

function path() {
  # Check for --raw or -r flag
  if [[ "$1" == "--raw" || "$1" == "-r" ]]; then
    # Print all paths without checks or numbering
    for p in $path; do
      printf "%s\n" "$p"
    done
    return
  fi
  
  # Use a local counter for line numbers
  local i=1
  
  # Iterate through the zsh $path array
  for p in $path; do
    if [[ -d "$p" ]]; then
      # Existing directory: Green checkmark
      printf "%2d. \e[32m[✓]\e[0m %s\n" "$i" "$p"
    else
      # Missing directory: Red cross
      printf "%2d. \e[31m[✗]\e[0m %s\n" "$i" "$p"
    fi
    ((i++))
  done
}

function cf() {
  local file
  if [[ $# -eq 1 ]]; then
    file=$(fd --color=never -t f "$1" . | fzf -1 -0 --prompt="Navigate to > ")
  elif [[ $# -ge 2 ]]; then
    file=$(fd --color=never -t f "$1" "$2" | fzf -1 -0 --prompt="Navigate to > ")
  else
    file=$(fd --color=never -t f | fzf -1 -0 --prompt="Navigate to > ")
  fi

  if [[ -n "$file" ]]; then
    local target_dir
    target_dir=$(dirname "$file")
    cd "$target_dir" && ls -p
  else
    [[ -n "$*" ]] && echo "No matches found for: $*"
  fi
}

function os() {
  if [ $# -gt 0 ]; then
    printf '\033]52;c;%s\a' "$(printf '%s' "$1" | base64)"
  else
    printf '\033]52;c;%s\a' "$(base64)"
  fi
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

function codex-hard-restart() {
  emulate -L zsh

  local codex_bin="${commands[codex]}"
  local control_socket="$HOME/.codex/app-server-control/app-server-control.sock"
  local process_pattern='[c]odex.*app-server|[c]odex-code-mode-host'
  local server_pattern='[c]odex.*app-server.*--listen'
  local cli_version status
  local attempt

  if [[ -z "$codex_bin" || ! -x "$codex_bin" ]]; then
    print -u2 'codex-hard-restart: codex executable not found'
    return 127
  fi

  cli_version=$("$codex_bin" --version 2>/dev/null)
  cli_version=${cli_version#codex-cli }
  print "Restarting Codex app-server, proxy, and code-mode-host (${cli_version})..."

  "$codex_bin" app-server daemon stop >/dev/null 2>&1 || true
  command pkill -TERM -u "$EUID" -f "$process_pattern" 2>/dev/null || true

  for attempt in {1..20}; do
    command pgrep -u "$EUID" -f "$process_pattern" >/dev/null 2>&1 || break
    command sleep 0.1
  done

  if command pgrep -u "$EUID" -f "$process_pattern" >/dev/null 2>&1; then
    print 'Processes did not stop after SIGTERM; sending SIGKILL...'
    command pkill -KILL -u "$EUID" -f "$process_pattern" 2>/dev/null || true
    command sleep 0.2
  fi

  # A GUI client may immediately respawn the daemon. Accept it only when it
  # came from the currently installed Codex release.
  if command pgrep -u "$EUID" -f "$server_pattern" >/dev/null 2>&1; then
    status=$("$codex_bin" app-server daemon version 2>/dev/null)
    if [[ "$status" == *\"appServerVersion\":\"${cli_version}\"* ]]; then
      print -r -- "$status"
      print 'Codex services were respawned successfully.'
      return 0
    fi

    print -u2 'codex-hard-restart: a stale app-server respawned during cleanup'
    command pgrep -a -u "$EUID" -f "$process_pattern" >&2
    return 1
  fi

  command rm -f -- "$control_socket"
  "$codex_bin" app-server daemon start >/dev/null || return
  command sleep 0.5

  status=$("$codex_bin" app-server daemon version 2>/dev/null)
  print -r -- "$status"
  if [[ "$status" != *\"status\":\"running\"* || \
        "$status" != *\"appServerVersion\":\"${cli_version}\"* ]]; then
    print -u2 'codex-hard-restart: daemon did not restart on the current CLI version'
    return 1
  fi

  print 'Codex services restarted successfully.'
}

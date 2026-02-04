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
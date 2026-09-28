# Aliases

alias rp='realpath'
if (( $+commands[opencode] )); then
  alias cmt='opencode run "commit with your skill"'
else
  alias cmt="claude --dangerously-skip-permissions \"/commit\""
fi
alias fd="fd -HI -c always"
alias ll="eza -l --group-directories-first --icons --git --color=always"
alias la="eza -la --group-directories-first --icons --git --color=always"

function claude() {
  local flag="--dangerously-skip-permissions"
  (( $@[(I)$flag] || $@[(I)update] )) && command claude "$@" || command claude "$@" "$flag"
}

function codex() {
  local arg fast=0 profile=0 after_options=0 apps_explicit=0 i
  local -a args

  for arg in "$@"; do
    if (( after_options )); then
      args+=("$arg")
      continue
    fi

    case "$arg" in
      --) after_options=1; args+=("$arg") ;;
      --fast) fast=1 ;;
      --profile|--profile=*|-p) profile=1; args+=("$arg") ;;
      *) args+=("$arg") ;;
    esac
  done

  if (( profile )); then
    (( fast )) && args=(-c service_tier=fast "${args[@]}")
  else
    python3 "$HOME/.zsh/scripts/codex-service-tier.py" "$HOME/.codex/config.toml" "$fast" || return
  fi

  for (( i = 1; i <= ${#args}; i++ )); do
    case "${args[i]}" in
      --) break ;;
      --enable|--disable)
        [[ "${args[i+1]}" == apps ]] && apps_explicit=1 ;;
      -c|--config)
        [[ "${args[i+1]}" == features.apps=* ]] && apps_explicit=1 ;;
      --enable=apps|--disable=apps|--config=features.apps=*) apps_explicit=1 ;;
    esac
  done
  (( apps_explicit )) || args=(--disable apps "${args[@]}")

  if (( ${args[(I)--yolo]} || ${args[(I)--dangerously-bypass-approvals-and-sandbox]} )); then
    command codex "${args[@]}"
  else
    command codex --yolo "${args[@]}"
  fi
}

function gemini() {
  (( $@[(I)--yolo] || $@[(I)-y] )) \
    && command gemini "$@" || command gemini "$@" --yolo
}

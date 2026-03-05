# Aliases

alias rp='realpath'
alias cmt="claude --dangerously-skip-permissions \"/commit\""
alias fd="fd -HI -c always"
alias ll="eza -l --group-directories-first --icons --git --color=always"
alias la="eza -la --group-directories-first --icons --git --color=always"

function claude() {
  local flag="--dangerously-skip-permissions"
  (( $@[(I)$flag] || $@[(I)update] )) && command claude "$@" || command claude "$@" "$flag"
}

function codex() {
  (( $@[(I)--yolo] || $@[(I)--dangerously-bypass-approvals-and-sandbox] )) \
    && command codex "$@" || command codex "$@" --yolo
}

function gemini() {
  (( $@[(I)--yolo] || $@[(I)-y] )) \
    && command gemini "$@" || command gemini "$@" --yolo
}

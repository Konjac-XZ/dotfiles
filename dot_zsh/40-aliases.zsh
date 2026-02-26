# Aliases

alias rp='realpath'
alias cmt="claude --dangerously-skip-permissions \"commit with your skill\""
alias fd="fd -HI -c always"
alias ll="eza -l --group-directories-first --icons --git --color=always"

function claude() {
  local flag="--dangerously-skip-permissions"
  (( $@[(I)$flag] )) && command claude "$@" || command claude "$@" "$flag"
}

function codex() {
  local flag="--yolo"
  (( $@[(I)$flag] )) && command codex "$@" || command codex "$@" "$flag"
}

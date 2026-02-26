# Tool initializations

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Skip interactive hooks in non-interactive shells.
[[ "${IS_INTERACTIVE_SHELL:-0}" -eq 1 ]] || return 0

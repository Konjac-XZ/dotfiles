# Tool initializations

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"

function __load_nvm() {
  unset -f nvm node npm npx corepack __load_nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

function nvm() {
  __load_nvm
  nvm "$@"
}

function node() {
  __load_nvm
  node "$@"
}

function npm() {
  __load_nvm
  npm "$@"
}

function npx() {
  __load_nvm
  npx "$@"
}

function corepack() {
  __load_nvm
  corepack "$@"
}

# Bun
[ -s "/root/.bun/_bun" ] && source "/root/.bun/_bun"

# Skip interactive hooks in non-interactive shells.
[[ "${IS_INTERACTIVE_SHELL:-0}" -eq 1 ]] || return 0

# Direnv 
eval "$(direnv hook zsh)"

# zoxide
eval "$(zoxide init zsh)"

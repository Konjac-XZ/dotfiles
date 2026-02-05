# Tool initializations

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun
[ -s "/root/.bun/_bun" ] && source "/root/.bun/_bun"

# Direnv 
eval "$(direnv hook zsh)"

# fzf
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"

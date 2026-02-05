# Oh-My-Zsh configuration

export TERM="xterm-256color"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 7

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
plugins=( \
gitfast \
zsh-autosuggestions zsh-syntax-highlighting \
sudo \
fzf-tab fzf \
extract \
)

source $ZSH/oh-my-zsh.sh

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

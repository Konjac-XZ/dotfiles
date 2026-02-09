# Oh-My-Zsh configuration

# Skip Oh-My-Zsh and plugin loading in non-interactive shells.
[[ "${IS_INTERACTIVE_SHELL:-0}" -eq 1 ]] || return 0

export TERM="xterm-256color"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 7

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
plugins=(
gitfast
multipass
sudo
fzf
extract
uv
tmux
zoxide
direnv
)

load_third_party_plugin "zsh-ssh"
load_third_party_plugin "zsh-autosuggestions"
load_third_party_plugin "zsh-syntax-highlighting"
load_third_party_plugin "fzf-tab"


source $ZSH/oh-my-zsh.sh

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

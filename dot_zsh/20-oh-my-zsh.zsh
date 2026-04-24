# Oh-My-Zsh configuration

# Skip Oh-My-Zsh and plugin loading in non-interactive shells.
[[ "${IS_INTERACTIVE_SHELL:-0}" -eq 1 ]] || return 0

export TERM="xterm-256color"

export ZSH="$HOME/.oh-my-zsh"
[[ -r "$ZSH/oh-my-zsh.sh" ]] || return 0

if have_command starship; then
  ZSH_THEME=""
elif [[ -r "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme" ]] || [[ -r "$ZSH/themes/powerlevel10k.zsh-theme" ]]; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
else
  ZSH_THEME=""
fi
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 7

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
plugins=()
load_oh_my_zsh_plugin_when_command "gitfast" "git"
load_oh_my_zsh_plugin_when_command "multipass"
load_oh_my_zsh_plugin "sudo"
load_oh_my_zsh_plugin_when_command "fzf"
load_oh_my_zsh_plugin "extract"
load_oh_my_zsh_plugin_when_command "uv"
load_oh_my_zsh_plugin_when_command "tmux"
load_oh_my_zsh_plugin_when_command "zoxide"
load_oh_my_zsh_plugin_when_command "direnv"

load_third_party_plugin "zsh-ssh"
load_third_party_plugin "zsh-autosuggestions"
load_third_party_plugin "zsh-syntax-highlighting"
load_third_party_plugin "fzf-tab"


source "$ZSH/oh-my-zsh.sh"

# Keep Oh-My-Zsh terminal integration, but skip it once the terminal is no longer usable.
if (( $+functions[omz_termsupport_precmd] )); then
  functions -c omz_termsupport_precmd _orig_omz_termsupport_precmd
  function omz_termsupport_precmd() {
    [[ -t 1 && -t 2 ]] || return 0
    _orig_omz_termsupport_precmd "$@"
  }
fi

if (( $+functions[omz_termsupport_preexec] )); then
  functions -c omz_termsupport_preexec _orig_omz_termsupport_preexec
  function omz_termsupport_preexec() {
    [[ -t 1 && -t 2 ]] || return 0
    _orig_omz_termsupport_preexec "$@"
  }
fi

if (( $+functions[omz_termsupport_cwd] )); then
  functions -c omz_termsupport_cwd _orig_omz_termsupport_cwd
  function omz_termsupport_cwd() {
    [[ -t 1 && -t 2 ]] || return 0
    _orig_omz_termsupport_cwd "$@"
  }
fi

# Initialize Starship prompt when available; otherwise rely on the selected Oh-My-Zsh theme.
have_command starship && eval "$(starship init zsh)"

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  # Root shell can load full brew environment directly.
  if [[ $EUID -eq 0 ]] && [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
  else
    # Non-root shells: add brew binary dir only.
    for brew_path in /home/linuxbrew/.linuxbrew/bin "$HOME/.linuxbrew/bin" /opt/homebrew/bin /usr/local/bin; do
      if [[ -x "$brew_path/brew" ]]; then
        add_to_path "$brew_path"
        break
      fi
    done
  fi
fi

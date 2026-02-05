# Homebrew
if [ "$(id -u)" -eq 0 ] || sudo -n true 2>/dev/null; then
  # User is root or has sudo privileges - load full brew environment
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
else
  # No sudo privileges - just add brew to PATH if needed
  if ! command -v brew >/dev/null 2>&1; then
    # Check common brew locations and add to PATH
    for brew_path in /home/linuxbrew/.linuxbrew/bin "$HOME/.linuxbrew/bin" /opt/homebrew/bin /usr/local/bin; do
      if [ -x "$brew_path/brew" ]; then
        add_to_path "$brew_path"
        break
      fi
    done
  fi
fi
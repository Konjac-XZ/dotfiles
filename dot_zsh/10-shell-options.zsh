# Shell options and settings

# Disable beep sounds
setopt NO_BEEP
unsetopt HIST_BEEP
unsetopt LIST_BEEP

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt SHARE_HISTORY
unsetopt INC_APPEND_HISTORY
unsetopt INC_APPEND_HISTORY_TIME

# Disable core dumps
ulimit -c 0

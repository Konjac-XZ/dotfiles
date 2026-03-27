# Custom key bindings
[[ "${IS_INTERACTIVE_SHELL:-0}" -eq 1 ]] || return 0

# Pressing Ctrl+L will now both clear the terminal and run the 'clear' command.
function clear-screen-and-scrollback() {
    clear
    zle clear-screen
}
zle -N clear-screen-and-scrollback
bindkey '^L' clear-screen-and-scrollback

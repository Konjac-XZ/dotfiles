# Custom key bindings
[[ "${IS_INTERACTIVE_SHELL:-0}" -eq 1 ]] || return 0

# Pressing Ctrl+L will now both clear the terminal and run the 'clear' command.
function clear-screen-and-scrollback() {
    clear
    zle clear-screen
}
zle -N clear-screen-and-scrollback
bindkey '^L' clear-screen-and-scrollback

# Restore Ctrl+Backspace as backward-kill-word for terminals that send a
# distinct sequence instead of plain ^H/^?.
typeset -ga ctrl_backspace_sequences=(
    '^[[127;5u'  # CSI-u / modifyOtherKeys
    '^[[8;5u'    # Some terminals report Backspace as keycode 8
    '^[[^?'      # CSI with DEL payload
    '^[^H'       # Alt+Backspace fallback seen in some setups
    '^[^?'       # Alt+Backspace / DEL fallback
)

for sequence in $ctrl_backspace_sequences; do
    bindkey "$sequence" backward-kill-word
done

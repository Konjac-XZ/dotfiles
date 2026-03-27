# PATH configuration
# Interactive shell detection helper.
export IS_INTERACTIVE_SHELL=0
[[ -o interactive ]] && export IS_INTERACTIVE_SHELL=1

# Function to add a directory to PATH only if it's not already present
function add_to_path() {
    if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# Check whether a command is currently available on PATH.
function have_command() {
    (( $+commands[$1] ))
}

# Load a bundled Oh-My-Zsh plugin only if it exists.
function load_oh_my_zsh_plugin() {
    local plugin_name="$1"
    local plugin_dir="${ZSH:-$HOME/.oh-my-zsh}/plugins/${plugin_name}"

    if [[ -d "$plugin_dir" ]]; then
        plugins+=("$plugin_name")
    fi
}

# Load a bundled Oh-My-Zsh plugin only when its backing command exists.
function load_oh_my_zsh_plugin_when_command() {
    local plugin_name="$1"
    local command_name="${2:-$plugin_name}"

    have_command "$command_name" || return 0
    load_oh_my_zsh_plugin "$plugin_name"
}

# Load a third-party Oh-My-Zsh plugin only if installed locally.
function load_third_party_plugin() {
    local plugin_name="$1"
    local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/${plugin_name}"

    if [[ -d "$plugin_dir" ]]; then
        plugins+=("$plugin_name")
    fi
}

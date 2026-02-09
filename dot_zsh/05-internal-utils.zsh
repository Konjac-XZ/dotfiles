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

# Load a third-party Oh-My-Zsh plugin only if installed locally.
function load_third_party_plugin() {
    local plugin_name="$1"
    local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/${plugin_name}"

    if [[ -d "$plugin_dir" ]]; then
        plugins+=("$plugin_name")
    fi
}

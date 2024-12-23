# Set prompt
export PS1=$'\n'"%F{green}%n%f %F{blue}@%f %F{red}%/%f"$'\n'"> "

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Make sure wezterm knows what the cwd is
which wezterm 1>/dev/null 2>/dev/null && wezterm set-working-directory

# Aliases
alias l="ls --color -lha"

# Functions
# NVM is too slow to load at startup
nvm_load() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}


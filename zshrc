export PATH=$PATH:$HOME/.fzf/bin
export TMP=$HOME/.tmp
export TEMP=$HOME/.tmp
export EDITOR=vim

# Set prompt
export PS1=$'\n'"%F{green}%n%f %F{black}@%f %F{blue}%/%f"$'\n'"> "

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Set up theme in bat
export BAT_THEME="Nord"

# Make sure wezterm knows what the cwd is
which wezterm 1>/dev/null 2>/dev/null && wezterm set-working-directory

# Aliases
alias l="ls --color -lhAF"

# Functions
# NVM is too slow to load at startup
nvm_load() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

# kill all docker containers
docker_killall() {
    docker ps -q | xargs docker kill
}

# fossil stuff
export FOSSIL_USER=tnegri
alias fossildiff="fossil changes | awk '{print \$2}' | fzf --preview 'fossil diff {}'"

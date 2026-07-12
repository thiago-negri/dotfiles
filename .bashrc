[ -f "$HOME/.bashrc.local.sh" ] && . "$HOME/.bashrc.local.sh"

HISTSIZE=10000
shopt -qs histappend

# Aliases
alias ls="ls --color"

# NVM is too slow to load at startup, set up a 'nvm' function that lazily loads the actual NVM (and replaces itself).
if [ -f "$HOME/.nvm/nvm.sh" ]; then
    nvm() {
        NVM_DIR="$HOME/.nvm"
        export NVM_DIR
        . "$NVM_DIR/nvm.sh"
        [ -f ./.nvmrc ] && nvm use $(head -n 1 ./.nvmrc)
        nvm "$@"
    }
    nvm_load() {
        nvm current
    }
fi

# Make sure wezterm knows what the cwd is
# This defines the cwd when we switch the wez session, so new panels created on a session
# will start at the correct directory
if command -v wezterm &>/dev/null; then
    ww() {
        wezterm set-working-directory
    }
    ww
fi

# kill all docker containers
if command -v docker &>/dev/null; then
    docker_killall() {
        docker ps -q | xargs docker kill
    }
fi

[ -f "$HOME/.gg/gg.sh" ] && . "$HOME/.gg/gg.sh"

# Custom prompt
PS1='\n\e[90m\u@\h:\w\e[0m\n\$ '

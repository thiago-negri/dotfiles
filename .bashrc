[ -f "$HOME/.bashrc.local.sh" ] && . "$HOME/.bashrc.local.sh"

HISTSIZE=10000
shopt -qs histappend

# Aliases
alias l="ls --color -lhAF --group-directories-first"
alias ls="ls --color"

# Set up fzf key bindings and fuzzy completion.
if command -v fzf &>/dev/null; then
    # # Somewhat copied from `fzf --bash` output, this is the only thing I actually use, and
    # # the entire `eval "$(fzf --bash)` is too slow.
    # __fzf_history__() {
    #     local output script
    #     script='BEGIN { getc; $/ = "\n\t"; $HISTCOUNT = $ENV{last_hist} + 1 } s/^[ *]//; s/\n/\n\t/gm; print $HISTCOUNT - $. . "\t$_" if !$seen{$_}++'
    #     output=$(
    #         set +o pipefail
    #         builtin fc -lnr -2147483648 |
    #           last_hist=$(HISTTIMEFORMAT='' builtin history 1) command perl -n -l0 -e "$script" |
    #           fzf --height -40% --min-height 20+ --bind=ctrl-z:ignore \
    #             -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort \
    #             --wrap-sign '"$'\t'"↳ ' +m --read0 --query "$READLINE_LINE"
    #     ) || return
    #     READLINE_LINE=$(command perl -pe 's/^\d*\t//' <<< "$output")
    #     if [[ -z "$READLINE_POINT" ]]; then
    #         echo "$READLINE_LINE"
    #     else
    #         READLINE_POINT=0x7fffffff
    #     fi
    # }
    # bind -m emacs-standard -x '"\C-r": __fzf_history__'
    #
    # If I really want all the fzf bells and whistles...
    fzf_load() {
        eval "$(fzf --bash)"
    }
fi

# NVM is too slow to load at startup, set up a 'nvm' function that lazily loads the actual NVM (and replaces itself).
if [ -f "$HOME/.nvm/nvm.sh" ]; then
    nvm() {
        NVM_DIR="$HOME/.nvm"
        export NVM_DIR
        . "$NVM_DIR/nvm.sh"
        [ -f ./.nvmrc ] && nvm use $(head -n 1 ./.nvmrc)
        nvm "$@"
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

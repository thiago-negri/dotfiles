# Make sure we're in a DBus session. This is the very first thing that
# bash will execute on login shells, so we exec into a new DBus session
# that will exec into a new bash login shell. The new bash login shell
# will have the envvar set and .bash_profile will continue to load
# normally. If this is misconfigured, it will keep exec'ing into itself.
if [ -z "$DBUS_SESSION_BUS_ADDRESS$DID_EXEC_DBUS_RUN_SESSION" ]; then
    export DID_EXEC_DBUS_RUN_SESSION=yes
    exec dbus-run-session -- bash -l
fi

# The current WezTerm release has an odd bug that makes it have a very
# slot startup sometimes because of a weird interaction with Xorg.
# It's already fixed, but they did not release a new version yet. This
# is a version built from their repo.
# I should revert to the one managed by xbps when this is properly released.
# https://github.com/wezterm/wezterm/issues/5884
export TERMINAL="$HOME/projects/wezterm/target/release/wezterm"

PATH="$PATH:$HOME/.fzf/bin"
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/.cargo/bin"
export PATH

export XDEB_PKGROOT="$HOME/.config/xdeb"

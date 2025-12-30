#!/bin/sh

prefix="/usr"
exec_prefix="${prefix}"
xrdb="xrdb"
xinitdir="/etc/X11/xinit"
xmodmap="xmodmap"

userresources="$HOME/.Xresources"
usermodmap="$HOME/.Xmodmap"
sysresources="$xinitdir/.Xresources"
sysmodmap="$xinitdir/.Xmodmap"

# merge in defaults and keymaps

if [ -f "$sysresources" ]; then
    if [ -x /usr/bin/cpp ] ; then
        "$xrdb" -merge "$sysresources"
    else
        "$xrdb" -nocpp -merge "$sysresources"
    fi
fi

if [ -f "$sysmodmap" ]; then
    "$xmodmap" "$sysmodmap"
fi

if [ -f "$userresources" ]; then
    if [ -x /usr/bin/cpp ] ; then
        "$xrdb" -merge "$userresources"
    else
        "$xrdb" -nocpp -merge "$userresources"
    fi
fi

if [ -f "$usermodmap" ]; then
    "$xmodmap" "$usermodmap"
fi

# start some nice programs

if [ -d "$xinitdir"/xinitrc.d ] ; then
	for f in "$xinitdir/xinitrc.d"/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

####

# Set keyboard layouts: us, us(intl). alt+shift to switch
setxkbmap -rules evdev -layout 'us,us' -variant ',intl' -option 'grp:alt_shift_toggle'

# disable mouse acceleration
xset m 0 0

# let nvidia render to intel outputs
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
# setup monitor resolutions
"$HOME/projects/utils/setup_monitors.sh"

# start my personal services
runsvdir "$HOME/service/sv" &
runsvdir_pid=$!

# start xscreensaver daemon
xscreensaver --no-splash &

# run herbstluftwm
# xfce4-session
herbstluftwm --locked
exit_code=$?

# stop personal services
kill -HUP $runsvdir_pid

exit $exit_code

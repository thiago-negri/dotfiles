#!/usr/bin/env bash

quote() {
	local q="$(printf '%q ' "$@")"
	printf '%s' "${q% }"
}

### dependencies, if missing this will not work as expected
textwidth="textwidth"
awk="awk"
xkblayoutnotify="$HOME/projects/xkblayoutnotify/xkblayoutnotify"
xkb_switch="xkb-switch"

# if [[ -f /usr/lib/bash/sleep ]]; then
#     # load and enable 'sleep' builtin (does not support unit suffixes: h, m, s!)
#     # requires pkg 'bash-builtins' on debian; included in 'bash' on arch.
#     enable -f /usr/lib/bash/sleep sleep
# fi

hc_quoted="$(quote "${herbstclient_command[@]:-herbstclient}")"
hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
monitor=${1:-0}
geometry=( $(hc monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format X Y W H
gx=${geometry[0]}
gy=${geometry[1]}
gw=${geometry[2]}
gh=${geometry[3]}
x=$gx
panel_width=$gw
panel_height=24
y=$(($gh - $panel_height))
font="-*-fixed-medium-*-*-*-20-*-*-*-*-*-*-*"
# extract colors from hlwm and omit alpha-value
bgcolor=$(hc get frame_border_normal_color|sed 's,^\(\#[0-9a-f]\{6\}\)[0-9a-f]\{2\}$,\1,')
selbg=$(hc get window_border_active_color|sed 's,^\(\#[0-9a-f]\{6\}\)[0-9a-f]\{2\}$,\1,')
selfg='#101010'

####
# textwidth="textwidth"
# if which textwidth &> /dev/null ; then
#     textwidth="textwidth";
# elif which dzen2-textwidth &> /dev/null ; then
#     textwidth="dzen2-textwidth";
# elif which xftwidth &> /dev/null ; then # For guix
#     textwidth="xftwidth";
# else
#     echo "This script requires the textwidth tool of the dzen2 project."
#     exit 1
# fi

# if awk -Wv 2>/dev/null | head -1 | grep -q '^mawk'; then
#     # mawk needs "-W interactive" to line-buffer stdout correctly
#     # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=593504
#     uniq_linebuffered() {
#       awk -W interactive '$0 != l { print ; l=$0 ; fflush(); }' "$@"
#     }
# else
    # other awk versions (e.g. gawk) issue a warning with "-W interactive", so
    # we don't want to use it there.
    uniq_linebuffered() {
      $awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
    }
# fi

padup=0
padright=0
paddown=$(($panel_height + 0))
padleft=0

hc pad $monitor $padup $padright $paddown $padleft

{
    ### Event generator ###
    # based on different input data (mpc, date, hlwm hooks, ...) this generates events, formed like this:
    #   <eventname>\t<data> [...]
    # e.g.
    #   date    ^fg(#efefef)18:33^fg(#909090), 2013-10-^fg(#efefef)29

    while true ; do
        printf 'date\t^fg(#efefef)%(%A)T^fg(#909090), ^fg(#efefef)%(%d)T^fg(#909090)/%(%m/%Y)T ^fg(#efefef)%(%H:%M)T\n'
        sleep 5 || break
    done > >(uniq_linebuffered) &
    datepid=$!
    $xkblayoutnotify &
    xkblayoutnotifypid=$!
    hc --idle
    kill $xkblayoutnotifypid
    kill $childpid
} 2> /dev/null | {
    IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
    visible=true
    date=""
    xkb_layout=""
    # windowtitle=""
    while true ; do

        ### Output ###
        # This part prints dzen data based on the _previous_ data handling run,
        # and then waits for the next event to happen.

        separator="^bg()^fg(#303030)|"
        # draw tags
        for i in "${tags[@]}" ; do
            case ${i:0:1} in
                '#') # focus
                    echo -n "^bg($selbg)^fg($selfg)"
                    ;;
                '+') # shown in this monitor, but not focus
                    echo -n "^bg(#9CA668)^fg(#141414)"
                    ;;
                ':') # not shown, has windows
                    echo -n "^bg()^fg(#ffffff)"
                    ;;
                '!') # urgent
                    echo -n "^bg(#FF0675)^fg(#141414)"
                    ;;
                *)
                    echo -n "^bg()^fg(#ababab)"
                    ;;
            esac
            echo -n "^ca(1,$hc_quoted focus_monitor \"$monitor\" && "
            echo -n "$hc_quoted use \"${i:1}\") ${i:1} ^ca()"
        done
        echo -n "$separator"
        # echo -n "^bg()^fg() ${windowtitle//^/^^}"
        # small adjustments
        clickable_xkb_layout="^fg(#a0a0a0)^ca(1,$xkb_switch -n) $xkb_layout ^ca()"
        right="$separator^bg()$clickable_xkb_layout$separator^bg() $date"
        right_text_only=$(echo -n "$right" | sed 's.\^[^(]*([^)]*)..g')
        # get width of right aligned text.. and add some space..
        width=$($textwidth "$font" "$right_text_only ")
        echo -n "^pa($(($panel_width - $width)))$right"
        echo

        ### Data handling ###
        # This part handles the events generated in the event loop, and sets
        # internal variables based on them. The event and its arguments are
        # read into the array cmd, then action is taken depending on the event
        # name.
        # "Special" events (quit_panel/togglehidepanel/reload) are also handled
        # here.

        # wait for next event
        IFS=$'\t' read -ra cmd || break
        # find out event origin
        case "${cmd[0]}" in
            ## custom events
            date)
                date="${cmd[@]:1}"
                ;;

            xkb_layout)
                if [ "${cmd[1]}" = "0" ] ; then
                    xkb_layout="us"
                else
                    xkb_layout="intl"
                fi
                ;;

            ## events from "herbstclient --idle"
            tag*)
                IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
                ;;
            quit_panel)
                exit
                ;;
            togglehidepanel)
                currentmonidx=$(hc list_monitors | sed -n '/\[FOCUS\]$/s/:.*//p')
                if [ "${cmd[1]}" -ne "$monitor" ] ; then
                    continue
                fi
                if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
                    continue
                fi
                echo "^togglehide()"
                if $visible ; then
                    visible=false
                    hc pad $monitor 0 0 0 0
                else
                    visible=true
                    hc pad $monitor $padup $padright $paddown $padleft
                fi
                ;;
            reload)
                exit
                ;;
            # focus_changed|window_title_changed)
            #     windowtitle="${cmd[@]:2}"
            #     ;;
        esac
    done

    ### dzen2 ###
    # After the data is gathered and processed, the output of the previous block
    # gets piped to dzen2.

} | dzen2 -w $panel_width -x $x -y $y -fn "$font" -h $panel_height \
    -e "button3=;button4=exec:$hc_quoted use_index -1;button5=exec:$hc_quoted use_index +1" \
    -ta l -bg "$bgcolor" -fg '#efefef'

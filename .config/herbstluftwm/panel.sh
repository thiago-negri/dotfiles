#!/usr/bin/env bash

monitor="$1"

# we start quite a few bg processes, clean them up when we die
trap 'kill $(jobs -p) 2>/dev/null' INT TERM

### dependencies, if missing this will not work as expected
hc=herbstclient
textwidth="$HOME/projects/xftwidth/xftwidth"
awk=awk
xkblayoutnotify="$HOME/projects/xkblayoutnotify/xkblayoutnotify"
voldown='wpctl set-volume @DEFAULT_SINK@ 3%- -l 1.0'
volup='wpctl set-volume @DEFAULT_SINK@ 3%+ -l 1.0'
mute='wpctl set-mute @DEFAULT_SINK@ toggle'
volnotify="$HOME/projects/utils/volnotify.sh"
xkb_switch=xkb-switch

### theme
# font='-*-fixed-medium-*-*-*-20-*-*-*-*-*-*-*'
font='Comic Code:size=12'
c0='#101010'
c1='#303030'
c2='#606060'
c3='#a0a0a0'
c4='#e0e0e0'
cr='#e06060'

### rect
# read -r mx my mw mh <<< $($hc monitor_rect "$monitor")
case "$monitor" in
    0)
        mx=1680
        mw=2560
        mh=1440
        ;;
    1)
        mx=0
        mw=1680
        mh=1050
        ;;
    *)
        echo "unknown monitor $monitor" >&2
        exit 1
        ;;
esac
pw=$mw
ph=24
px=$mx
py=$(($mh - $ph))

### pad hlwm screen space to reserve space for the panel
padup=0
padright=0
paddown=$ph
padleft=0
"$hc" pad $monitor $padup $padright $paddown $padleft

# ignore repeated lines
uniq_linebuffered() {
  "$awk" '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

{
    ### Event generator ###
    # <eventname>\t<data1>\t<data2>\t<...>\n

    # current date and time, 1s
    while true ; do
        # date weekday year month day hour minute
        printf 'date\t%(%A)T\t%(%Y)T\t%(%m)T\t%(%d)T\t%(%H)T\t%(%M)T\n'
        sleep 1 || break
    done > >(uniq_linebuffered) &

    # ethernet status, 5s
    while true ; do
        # enp status ip
        IFS=' /' read -r _ st addr _ <<< $(ip -br addr show enp109s0)
        printf "enp\t$st\t$addr\n"
        sleep 5 || break
    done > >(uniq_linebuffered) &

    # wifi status, 5s
    while true ; do
        # wlp status ip
        IFS=' /' read -r _ st addr _ <<< $(ip -br addr show wlp0s20f3)
        if [ "$st" = "UP" ]; then
            wlp_name=$(nmcli connection show --active | grep wlp0s20f3 | awk '{print $1}')
        else
            wlp_name=""
        fi
        printf "wlp\t$st\t$addr\t$wlp_name\n"
        sleep 5 || break
    done > >(uniq_linebuffered) &

    # keyboard layout
    "$xkblayoutnotify" &

    # volume
    "$volnotify" &

    # hlwm events, this will block
    "$hc" --idle

    kill $(jobs -p)
} 2>/dev/null | {
    separator="^bg()^fg($c1) | "

    # starting values
    IFS=$'\t' read -ra tags <<< "$($hc tag_status $monitor)"
    visible=true
    date=""
    xkb_layout=""
    volume=" ^fg($c2)V ^fg($c4)????? "
    enp=""
    wlp=""
    windowtitle=""

    while true ; do

        ### Output ###

        # tags
        for i in "${tags[@]}" ; do
            # color
            case ${i:0:1} in
                '#') # focus
                    echo -n "^bg($c3)^fg($c0)"
                    ;;
                '+') # shown in this monitor, but not focus
                    echo -n "^bg($c1)^fg($c3)"
                    ;;
                ':') # not shown, has windows
                    echo -n "^bg()^fg($c3)"
                    ;;
                '!') # urgent
                    echo -n "^bg($cr)^fg($c0)"
                    ;;
                *)
                    echo -n "^bg()^fg($c1)"
                    ;;
            esac
            # clickable tag number
            echo -n "^ca(1,$hc chain . focus_monitor \"$monitor\" . use \"${i:1}\") ${i:1} ^ca()"
        done

        echo -n "$separator"

        echo -n "^bg()^fg($c3) ${windowtitle//^/^^}"

        # keyboard layout
        dzen_xkblayout="^fg($c3)^ca(1,$xkb_switch -n) $xkb_layout ^ca()"

        # volume color
        # clickable volume indicator
        dzen_vol="^ca(1,$mute)$volume^ca()"

        # full right bar
        right="$wlp$separator$enp$separator$dzen_vol$separator$dzen_xkblayout$separator$date"
        right_text=$(echo -n "$right" | sed 's.\(\^[^(]*([^)]*)\)\|MUTED\|?????..g')
        # width of right aligned text
        width=$($textwidth "$font" "$right_text")
        echo -n "^pa($(($pw - $width - 60)))$right"
        echo


        ### Data handling ###

        # wait for next event
        if ! IFS=$'\t' read -ra cmd; then
            kill $(jobs -p) 2>/dev/null
            break
        fi

        # echo "${cmd[*]}" >>"$HOME/panel_$monitor.log"

        # find out event origin
        case "${cmd[0]}" in
            ## custom events
            date)
                date=" ^fg($c3)${cmd[1]}^fg($c2), ${cmd[2]}-${cmd[3]}-^fg($c3)${cmd[4]} ${cmd[5]}:${cmd[6]} "
                ;;

            xkb_layout)
                if [ "${cmd[1]}" = "0" ]; then
                    xkb_layout="^fg($c2)K ^fg($c3)us"
                else
                    xkb_layout="^fg($c2)K ^fg($c3)intl"
                fi
                ;;

            vol)
                if [ -z "${cmd[1]}" ]; then
                    volume=" ^fg($c2)V ^fg($c3)????? "
                elif [ "${cmd[1]}" = "MUTED" ]; then
                    volume=" ^fg($c2)V ^fg($c3)MUTED "
                else
                    volfil=$(( ${cmd[1]} / 2 ))
                    volemp=$(( 50 - (${cmd[1]} / 2) ))
                    volume=" ^fg($c2)V ^fg($c3)^r(${volfil}x10)^fg($c1)^r(${volemp}x10) "
                fi
                ;;

            enp)
                case "${cmd[1]}" in
                    UP) enp=" ^fg($c2)E ^fg($c3)${cmd[2]} ";;
                    * ) enp=" ^fg($c2)E ^fg($c3)${cmd[1]} ";;
                esac
                ;;

            wlp)
                case "${cmd[1]}" in
                    UP) wlp=" ^fg($c2)W ^fg($c3)${cmd[2]} ^fg($c2)${cmd[3]} ";;
                    * ) wlp=" ^fg($c2)W ^fg($c3)${cmd[1]} ";;
                esac
                ;;

            ## events from "herbstclient --idle"
            tag*)
                IFS=$'\t' read -ra tags <<< "$($hc tag_status $monitor)"
                ;;
            quit_panel)
                kill $(jobs -p) 2>/dev/null
                exit
                ;;
            togglehidepanel)
                currentmonidx=$($hc list_monitors | sed -n '/\[FOCUS\]$/s/:.*//p')
                if [ "${cmd[1]}" -ne "$monitor" ] ; then
                    continue
                fi
                if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
                    continue
                fi
                echo "^togglehide()"
                if $visible ; then
                    visible=false
                    $hc pad $monitor 0 0 0 0
                else
                    visible=true
                    $hc pad $monitor $padup $padright $paddown $padleft
                fi
                ;;
            reload)
                kill $(jobs -p) 2>/dev/null
                exit
                ;;
            focus_changed|window_title_changed)
                windowtitle="${cmd[@]:2}"
                ;;
        esac
    done

    ### dzen2 ###
    # After the data is gathered and processed, the output of the previous block
    # gets piped to dzen2.

} | dzen2 -w $pw -h $ph -x $px -y $py -fn "$font" \
    -e "button3=;button4=exec:$volup;button5=exec:$voldown" \
    -ta l -bg "$c0" -fg "$c3"

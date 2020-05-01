#!/bin/bash

export NCURSES_NO_UTF8_ACS=1

start_tty2() {
    sleep 12s
    #switch to tty2, clear screen and display boinctui
    chvt 2
    printf "\033c" > /dev/tty2
    boinctui 2> /dev/null > /dev/tty2
}

[ -z "$SKIP_BOINCTUI_TTY" ] && start_tty2 &

# start gotty with boinctui
exec /usr/app/gotty -w -p 80 boinctui

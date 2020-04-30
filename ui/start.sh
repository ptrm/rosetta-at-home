#! /bin/bash

# start gotty with boinctui
gotty_pid=''
gotty_port=80

start_webui () {
  /usr/app/gotty -w -p $gotty_port boinctui&
  gotty_pid="$!"
}

kill_webui () {
  [ -n "$gotty_pid" ] && kill -9 $gotty_pid
}

start_webui

while true; do
    sleep 30s

    curl -sf -o /dev/null http://localhost:$gotty_port

    if [[ $? -ne 0 ]]; then
      ps -p $gotty_pid && {
        >&2 echo "gotty is stalled - restarting";
        kill_webui;
        start_webui;
      } || {
        >&2 echo "gotty exited - restarting";
        start_webui;
      }
    fi
done &

export NCURSES_NO_UTF8_ACS=1
#switch to tty2, clear screen and display boinctui 
chvt 2
printf "\033c" > /dev/tty2
exec boinctui 2> /dev/null > /dev/tty2

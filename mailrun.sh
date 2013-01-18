#!/bin/bash
read -r pid < ~/.offlineimap/pid

if ps $pid &>/dev/null; then
  echo "offlineimap ($pid): another instance running." >&2
  #kill -9 $pid
else
    export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(ps -au $USER | grep -i "gnome-session" | awk '{ print $1 }')/environ | sed -e 's/DBUS_SESSION_BUS_ADDRESS=//')
    export DISPLAY=:0
    #echo $DBUS_SESSION_BUS_ADDRESS >> ~/.offlineimap/log
    #echo "foo" >> ~/.offlineimap/log
    offlineimap -o -u quiet >> ~/.offlineimap/log 2>&1
    dbus-send --session --dest="org.gnu.Emacs" "/org/gnu/Emacs" "org.gnu.Emacs.NotmuchNewmail"
fi

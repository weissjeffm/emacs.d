#!/bin/bash
read -r pid < ~/.offlineimap/pid
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(ps -au $USER | grep -i "gnome-session" | awk '{ print $1 }')/environ | sed -e 's/DBUS_SESSION_BUS_ADDRESS=//')
export DISPLAY=:0

if ps $pid &>/dev/null; then
    echo "offlineimap ($pid): instance running." >&2
    #kill -9 $pid
else
    #start it
    offlineimap -o -u quiet >> ~/.offlineimap/log 2>&1
    #disown %1
fi
notmuch new
dbus-send --session --dest="org.gnu.Emacs" "/org/gnu/Emacs" "org.gnu.Emacs.NotmuchNewmail"

#!/bin/sh

USER=kboes
#SERVER=xsystems.org
SERVER=192.168.0.10
REMOTE_PORT=49152
LH=127.0.0.1
LOCAL_PORT=49152
SSH_OPTIONS='-N -f -C -L'
#BROWSER='x-www-browser'
BROWSER='firefox -private'
#BROWSER='firefox -private -new-window'
#BROWSER='google-chrome --incognito --new-window'

tunnel_exists=$(nmap -p $LOCAL_PORT $LH | grep -c open)

if [ $tunnel_exists -lt "1" ] ; then
	autossh $SSH_OPTIONS $LOCAL_PORT:$LH:$REMOTE_PORT $USER@$SERVER \
	&& sleep 3 \
	&& $BROWSER $LH:$LOCAL_PORT &
else
	echo "Tunnel from $SERVER:$REMOTE_PORT to $LH:$LOCAL_PORT already exists!"
	$BROWSER $LH:$LOCAL_PORT &
fi


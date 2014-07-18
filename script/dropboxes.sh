#!/bin/bash
DROPBOX_DIR="/home/$USER/doc/dropbox"

dropboxes=".personal"

for dropbox in $dropboxes
do
    if ! [ -d "$DROPBOX_DIR/$dropbox" ]
    then
        mkdir -p "$DROPBOX_DIR/$dropbox" 2> /dev/null
        ln -s "/home/$USER/.Xauthority" "$DROPBOX_DIR/$dropbox/" 2> /dev/null
    fi
    HOME="$DROPBOX_DIR/$dropbox" dropboxd 2> /dev/null &
done

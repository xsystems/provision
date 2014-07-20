#!/bin/sh

LINK_NAME_PREFIX="/home/$USER"

CONFIGS_HOME_HIDDEN=$(cat <<EOF
bash_aliases
bash_logout
bash_profile
bashrc
conkyrc
fonts
inputrc
moc
nano
nanorc
profile
xbindkeysrc
xinitrc
Xresources
EOF
)

alias ln="ln --backup=numbered -r -T -s"

function provision () {
    [ $# -ne 2 ] && exit 1

    local TARGET=$1
    local LINK_NAME=$2

    if [ ! -e $LINK_NAME ] || [ ! $TARGET -ef $LINK_NAME ] ; then
        ln $TARGET $LINK_NAME
    fi
}

for TARGET in $CONFIGS_HOME_HIDDEN
do
    provision $TARGET "$LINK_NAME_PREFIX/.$TARGET"
done

TARGET="awesome"
provision $TARGET "$LINK_NAME_PREFIX/.config/$TARGET"

unalias ln

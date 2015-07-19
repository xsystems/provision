#!/bin/sh

LINK_NAME_PREFIX_HOME="/home/$USER"
LINK_NAME_PREFIX_CONFIG="$LINK_NAME_PREFIX_HOME/.config"
mkdir -p $LINK_NAME_PREFIX_CONFIG

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
npmrc
profile
xbindkeysrc
xinitrc
Xresources
EOF
)

CONFIGS_CONFIG=$(cat <<EOF
awesomme
locale.conf
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
    provision $TARGET "$LINK_NAME_PREFIX_HOME/.$TARGET"
done

for TARGET in $CONFIGS_CONFIG
do
    provision $TARGET "$LINK_NAME_PREFIX_CONFIG/$TARGET"
done

unalias ln

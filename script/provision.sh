#!/bin/sh

LINK_NAME_PREFIX="/home/$USER/bin"

SCRIPTS_HOME_BIN=$(cat <<EOF
backup_home
dropboxes
ssh_forward_transmission
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

for TARGET_PREFIX in $SCRIPTS_HOME_BIN
do
    provision "$TARGET_PREFIX.sh" "$LINK_NAME_PREFIX/$TARGET_PREFIX"
done

unalias ln

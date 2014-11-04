#!/bin/sh

LINK_NAME_PREFIX="/home/$USER"

mkdir $LINK_NAME_PREFIX/log

(cd config && . ./provision.sh)
(cd script && . ./provision.sh)

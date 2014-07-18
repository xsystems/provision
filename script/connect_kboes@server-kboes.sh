#!/bin/sh

ssh -f -C -L 	5900:localhost:5900 kboes@xsystems.dyndns.org \
        		x11vnc -xkb -safer -localhost -nopw -once -display :0 \
&& sleep 3 \
&& vinagre localhost:0

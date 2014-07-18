#!/bin/sh

ssh -f -C -L 	5900:localhost:5900 kboes@xsystems.dyndns.org \
        	sudo 	x11vnc 	-safer -localhost -nopw -once \
                    		-auth /var/lib/gdm/:0.Xauth -display :0 \
		&& 	sleep 3 \
        	&&  	vinagre localhost:0

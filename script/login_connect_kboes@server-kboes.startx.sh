#!/bin/sh

ssh -t -f -C -L 5900:localhost:5900 kboes@xsystems.dyndns.org \
        	sudo 	x11vnc 	-create -safer -localhost -nopw -once \
                    		-auth ~/.Xauthority -display :0 \
		&& 	sleep 3 \
        	&&  	vinagre localhost:0

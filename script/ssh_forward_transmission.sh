#!/bin/sh

/usr/bin/autossh -M 0 -T -N -C -L 49000:127.0.0.1:9091 ${USER}@0.physical.xsystems.org &

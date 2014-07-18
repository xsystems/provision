#!/bin/bash

pids=()

/usr/bin/autossh -M 0 -T -N -C -L 3307:127.0.0.1:3306 xsystems.org &
pids+=($!)
/usr/bin/autossh -M 0 -T -N -C -L 6543:127.0.0.1:6543 xsystems.org &
pids+=($!)

xbmc

for pid in "${pids[@]}"
do
   kill $pid
done

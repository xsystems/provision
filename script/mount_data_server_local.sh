#!/bin/sh

sshfs -o follow_symlinks -o reconnect -o idmap=user $USER@192.168.0.10:/media/data /media/server_data

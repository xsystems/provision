#!/bin/sh

sshfs -o follow_symlinks -o reconnect -o idmap=user $USER@xsystems.org:/media/data /media/server_data

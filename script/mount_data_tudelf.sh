#!/bin/sh

sshfs -o follow_symlinks -o reconnect -o idmap=user $USER@sftp.tudelft.nl:/student-homes/b/kboes/ /media/webdata/
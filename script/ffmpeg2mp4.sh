#!/bin/bash

maxConcurrentProcesses=4
concurrentProcesses=0

for file in "$@"; do
    extension="${file##*.}"
    basename="${file##*/}"
    filename="${basename%.*}"
    fileNoExtension="${file%.*}"

    #echo "Basename: $basename"
    #echo "Filename: $filename"
    #echo "Extension: $extension"
    #echo "File no Extension: $fileNoExtension"
    #echo "File: $file"
    #echo "${filename}_HD480_1000K_24FPS.mp4"

    avconv -i "$file" -c:v libx264 -r 24 -s hd480 -b:v 1000k -c:a aac -b:a 320k -strict experimental "${filename}_HD480_1000K_24FPS.mp4" > /dev/null 2>&1 &

    echo "Converting: $filename"

    concurrentProcesses=$(($concurrentProcesses+1))
    if [ "$concurrentProcesses" -ge "$maxConcurrentProcesses" ]; then
        wait
        concurrentProcesses=0
    fi
done

#Wait for all processes to finish
wait

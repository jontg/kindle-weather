#!/bin/sh

cd "$(dirname "$0")"

eips -c
eips -c

FILE=`find /mnt/us/weather -mmin -60 -name weather-uploaded-output.png`

if [[ -f "$FILE" ]]; then
        eips -g weather-uploaded-output.png
else
        eips -g weather-image-error.png
fi

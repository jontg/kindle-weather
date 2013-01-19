#!/bin/sh

cd "$(dirname "$0")"

python2 weather-script.py
rsvg-convert --background-color=white -o weather-script-output-pre.png weather-script-output.svg
pngcrush -c 0 -ow weather-script-output-pre.png weather-script-output.png
rcp weather-script-output.png root@192.168.2.2:/mnt/us/weather/weather-uploaded-output.png >/dev/null

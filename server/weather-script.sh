#!/bin/sh

cd "$(dirname "$0")"

ruby bin/kindle-weather

rsvg-convert --background-color=white -o output/weather-script-output-pre.png output/weather-script-output.svg
curl -X POST -s --form "input=@output/weather-script-output-pre.png;type=image/png" http://pngcrush.com/crush > output/weather-script-output.png
# rcp output/weather-script-output.png root@192.168.2.2:/mnt/us/weather/weather-uploaded-output.png >/dev/null

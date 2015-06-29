#!/bin/bash -ex

cd "$(dirname "$0")"

ruby bin/kindle-weather

cp weather-script-icons.svg output/
rsvg-convert --background-color=white -o output/weather-script-output-pre.png output/weather-script-output.svg

pushd output
    pngcrush -c 0 weather-script-output-pre.png weather-script-output.png
popd

if [[ ! "${DO_DEPLOY}" -eq "" ]]; then
    rcp output/weather-script-output.png root@192.168.2.2:/mnt/us/weather/weather-uploaded-output.png >/dev/null
fi

#!/bin/bash

sudo ln -s /home/jontg/Development/kindle-weather/server/logrotate /etc/logrotate.d/kindle-weather

cat <<-EOF | EDITOR=">" crontab -e
	55 * * * * /home/jontg/Development/kindle-weather/server/weather-script.sh >> /home/jontg/log/weather-script.log 2>&1
EOF

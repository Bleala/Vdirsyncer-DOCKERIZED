#!/bin/sh
# Welcome Message
echo 'Welcome to Vdirsyncer DOCKERIZED! :)

For more information please visit the official docs page.
There you will also find configuration examples.
https://vdirsyncer.pimutils.org/en/stable/index.html

If you have any problems with Vdirsyncer, please
visit the Github repo and open an issue.
https://github.com/pimutils/vdirsyncer

If there is a problem with the container,
contact me or open an issue in my Github repo.
https://github.com/Bleala/Vdirsyncer-DOCKERIZED
I am trying to fix it, so that everything
is running as expected. :)

Enjoy!

'
# Set Date and Time when Container is starting
DATE=$(date +%d-%b-%y-%H_%M_%S)

# Create Log File
cp -rf "$LOG" "$LOG-$DATE"
curl --create-dirs --output $LOG file:///dev/null &> /dev/null

# Copy config.example to workdir
cp /examples/config.example /vdirsyncer

# Starting logging
echo 'Starting Logging...
' | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG

# Set up Container Timezone
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo "$TZ" > /etc/timezone
echo "Set Timezone to $TZ"  | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG
echo "Current time is $(date)"  | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG

# Set up Vdirsyncer
sh /scripts/sync.sh 2>&1 | tee -a $LOG

# Run Container
exec tail -f /dev/null

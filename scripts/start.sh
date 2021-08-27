#!/bin/sh

echo 'Welcome to Vdirsyncer DOCKERIZED! :)

For more information please visit the official docs page.
There you will also find configuration examples.
https://vdirsyncer.pimutils.org/en/stable/index.html

If you have any problems with Vdirsyncer, please
visit the Github repo and open an issue.
https://github.com/pimutils/vdirsyncer

If there is a problem with the container,
contact me or open an issue in my Github repo.
I am trying to fix it, so that everything
is running as expected. :)

Enjoy!

'
DATE=$(date +%d-%b-%y-%H_%M_%S)
cp -rf "$LOG" "$LOG-$DATE"
curl --create-dirs --output $LOG file:///dev/null &> /dev/null
cp /examples/config.example /vdirsyncer
echo 'Starting Logging...
' | tee -a $LOG
sh /scripts/sync.sh 2>&1
exec tail -f /dev/null
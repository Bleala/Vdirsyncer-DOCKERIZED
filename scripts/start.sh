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

Enjoy!'

printf "\n"

# Set Date and Time when Container is starting
DATE=$(date +%d-%b-%y-%H_%M_%S)

# Create Log File
cp -rf "$LOG" "$LOG-$DATE"
rm "$LOG-$DATE"
curl --create-dirs --output $LOG file:///dev/null &> /dev/null

# Starting logging
echo 'Starting Logging...
' | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG

# Switch to root
sudo su - <<EOF

# Set up Container Timezone
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo "$TZ" > /etc/timezone
echo "Set Timezone to $TZ"  | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG
echo "Current time is $(date)"  | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG

# Change permissions
chown -R $UID:$GID /scripts
chown -R $UID:$GID /vdirsyncer
chown -R $UID:$GID /examples
chown -R $UID:$GID $LOG
chmod -R 755 /vdirsyncer

### Set UID and GID
# Only execute if GID changed
if [[ $GID -ne $INIT_GID ]]
then
    # Change GID
    groupmod -g $GID $USER
fi

# Only execute if UID changed
if [[ $UID -ne $INIT_UID ]]
then
    # Change UID
    usermod -u $UID $USER
fi


### Set up Cronjob ###
# Copy original Crontab File to root directory
cp /root/crontab /etc/crontabs/$USER

# Append to crontab file if autodiscover and autosync are true
if [[ $AUTODISCOVER == true ]] && [[ $AUTOSYNC == true ]]
then
    echo "$CRON_TIME yes | vdirsyncer -c $VDIRSYNCER_CONFIG discover && vdirsyncer -c $VDIRSYNCER_CONFIG metasync && vdirsyncer -c $VDIRSYNCER_CONFIG sync" >> /etc/crontabs/$USER 
    echo 'Autodiscover and Autosync are enabled' 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a $LOG
    exec crond -l 8 -d 8 -f 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a $LOG

# Append to crontab file if autosync is true
elif [[ $AUTODISCOVER == false ]] && [[ $AUTOSYNC == true ]]
then
    echo "$CRON_TIME vdirsyncer -c $VDIRSYNCER_CONFIG metasync && vdirsyncer -c $VDIRSYNCER_CONFIG sync" >> /etc/crontabs/$USER 
    echo 'Only Autosync is enabled' 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a $LOG
    exec crond -l 8 -d 8 -f 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a $LOG

# Append to crontab file if autodiscover is true
elif [[ $AUTODISCOVER == true ]] && [[ $AUTOSYNC == false ]]
then
    echo "$CRON_TIME yes | vdirsyncer -c $VDIRSYNCER_CONFIG discover" >> /etc/crontabs/$USER 
    echo 'Only Autodiscover is enabled' 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a $LOG
    exec crond -l 8 -d 8 -f 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a $LOG

# Append nothing, if both options are disabled
else
    echo 'Autodiscover and Autosync are disabled' 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a $LOG

fi

# End root
EOF

# Run Container
exec tail -f /dev/null

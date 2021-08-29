#!/bin/sh

if [ $AUTODISCOVER = true ] && [ $AUTOSYNC = true ]; then
    echo "$CRON_TIME yes | vdirsyncer discover && vdirsyncer metasync && vdirsyncer sync" >> /etc/crontabs/root
    echo 'Autodiscover and Autosync are enabled' 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG
    exec crond -l 8 -d 8 -f 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG

elif [ $AUTODISCOVER = false ] && [ $AUTOSYNC = true ]; then
    echo "$CRON_TIME vdirsyncer metasync && vdirsyncer sync" >> /etc/crontabs/root
    echo 'Only Autosync is enabled' 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG
    exec crond -l 8 -d 8 -f 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG

elif [ $AUTODISCOVER = true ] && [ $AUTOSYNC = false ]; then
    echo "$CRON_TIME yes | vdirsyncer discover" >> /etc/crontabs/root
    echo 'Only Autodiscover is enabled' 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG
    exec crond -l 8 -d 8 -f 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG

else
    echo 'Autodiscover and Autosync are disabled' 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a $LOG

fi
#!/bin/bash
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

# Create Log File
curl --create-dirs --output "${LOG}" file:///dev/null > /dev/null 2>&1
# Save exit code
LOG_FILE_CREATED="${?}"
# Check if Log File has been created
if [[ "${LOG_FILE_CREATED}" -ne 0 ]]
then
    # User info
    echo "Logfile could not be created!"  | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
    echo "Container exits!"  | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
    echo "Check the \"LOG\" environment variable."  | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
    # Exit Container
    exit 1
fi

# Copy config.example to vdirsyncer directory
cp /files/examples/config.example /vdirsyncer/config.example

# Starting logging
echo 'Starting Logging...
' | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

# Log current Timezone and Date/Time
echo "Current timezone is ${TZ}"  | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
echo "Current time is $(date)"  | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

### Set up Cronjobs ###
# Append to crontab file if autodiscover and autosync are true
if [[ "${AUTODISCOVER}" == true ]] && [[ "${AUTOSYNC}" == true ]]
then
    echo "${CRON_TIME} yes | vdirsyncer -c ${VDIRSYNCER_CONFIG} discover && vdirsyncer -c ${VDIRSYNCER_CONFIG} metasync && vdirsyncer -c ${VDIRSYNCER_CONFIG} sync" >> /etc/crontabs/"${VDIRSYNCER_USER}" 
    echo 'Autodiscover and Autosync are enabled' 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"
    exec crond -l 8 -d 8 -f 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"

# Append to crontab file if autosync is true
elif [[ "${AUTODISCOVER}" == false ]] && [[ "${AUTOSYNC}" == true ]]
then
    echo "${CRON_TIME} vdirsyncer -c ${VDIRSYNCER_CONFIG} metasync && vdirsyncer -c ${VDIRSYNCER_CONFIG} sync" >> /etc/crontabs/"${VDIRSYNCER_USER}"
    echo 'Only Autosync is enabled' 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"
    exec crond -l 8 -d 8 -f 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"

# Append to crontab file if autodiscover is true
elif [[ "${AUTODISCOVER}" == true ]] && [[ "${AUTOSYNC}" == false ]]
then
    echo "${CRON_TIME} yes | vdirsyncer -c ${VDIRSYNCER_CONFIG} discover" >> /etc/crontabs/"${VDIRSYNCER_USER}"
    echo 'Only Autodiscover is enabled' 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"
    exec crond -l 8 -d 8 -f 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"

# Append nothing, if both options are disabled
else
    echo 'Autodiscover and Autosync are disabled' 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"

fi

# Run Container
exec tail -f /dev/null

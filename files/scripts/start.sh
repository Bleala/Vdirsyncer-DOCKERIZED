#!/bin/bash
# Check if a logfile exists
if [[ -e "${LOG}" ]]
then
    # Delete old logfiles
    rm -f "${LOG}" > /dev/null 2>&1
    # User info
    {
        echo "Old logfile has been deleted."
        printf "\n"
    } | ts '[%Y-%m-%d %H:%M:%S]'
fi

# Create Log File
curl --create-dirs --output "${LOG}" file:///dev/null > /dev/null 2>&1
# Save exit code
LOG_FILE_CREATED="${?}"
# Check if Log File has been created
if [[ "${LOG_FILE_CREATED}" -ne 0 ]]
then
    # User info
    {
        echo "Logfile could not be created!"
        echo "Container exits!"
        echo "Check the \"LOG\" environment variable."
    }  | ts '[%Y-%m-%d %H:%M:%S]'
    # Exit Container
    exit 1
fi

# Welcome Message
{
    echo "Welcome to Vdirsyncer DOCKERIZED! :)"
    printf "\n"

    echo "For more information please visit the official docs page."
    echo "There you will also find configuration examples."
    echo "https://vdirsyncer.pimutils.org/en/stable/index.html"
    printf "\n"

    echo "If you have any problems with Vdirsyncer, please"
    echo "visit the Github repo and open an issue."
    echo "https://github.com/pimutils/vdirsyncer"
    printf "\n"

    echo "If there is a problem with the container,"
    echo "contact me or open an issue in my Github repo."
    echo "https://github.com/Bleala/Vdirsyncer-DOCKERIZED"
    echo "I am trying to fix it, so that everything"
    echo "is running as expected. :)"
    printf "\n"

    echo "Enjoy!"
    printf "\n"
} | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

# Starting logging
{
    echo "Starting Logging..."
    printf "\n"
} | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

if [[ "${LOG_FILE_CREATED}" -eq 0 ]]
then
    # User info
    {
        echo "New logfile has been created."
        printf "\n"
    } | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
fi

# Log current Timezone and Date/Time
{
    echo "Current timezone is ${TZ}"
    echo "Current time is $(date)"
    printf "\n"
} | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

# Check if the config.example exists
if [[ ! -e "/vdirsyncer/config.example" ]]
then
    # Copy config.example to vdirsyncer directory
    cp /files/examples/config.example /vdirsyncer/config.example
    # User info
    {
        echo "config.example has been copied to /vdirsyncer."
        printf "\n"
    } | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
fi

# Check if Autoupdate is enabled
if [[ "${AUTOUPDATE}" == "true" ]]
then
    {
        # User info
        echo "#######################################"
        echo "Autoupdate of Vdirsyncer is enabled."
        echo "Starting update..."
        printf "\n"

        # Vdirsyncer update
        pipx upgrade --include-injected vdirsyncer

        # Save exit code of update
        UPDATE_SUCCESSFUL="${?}"

        # Check if update was successful
        if [[ "${UPDATE_SUCCESSFUL}" -eq 0 ]]
        then
            # User info
            printf "\n"
            echo "Vdirsyncer update was successful."
        else
            printf "\n"
            echo "Vdirsyncer update FAILED!"
        fi
        
        # End of update
        echo "#######################################"
        printf "\n"
    } | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
fi

### Set up Cronjobs ###
# Append to crontab file if autodiscover and autosync are true
if [[ "${AUTODISCOVER}" == "true" ]] && [[ "${AUTOSYNC}" == "true" ]]
then
    echo "${CRON_TIME} yes | vdirsyncer -c ${VDIRSYNCER_CONFIG} discover && vdirsyncer -c ${VDIRSYNCER_CONFIG} metasync && vdirsyncer -c ${VDIRSYNCER_CONFIG} sync" >> /etc/crontabs/"${VDIRSYNCER_USER}" 
    echo 'Autodiscover and Autosync are enabled.' 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"
    exec crond -l 8 -d 8 -f 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"

# Append to crontab file if autosync is true
elif [[ "${AUTODISCOVER}" == "false" ]] && [[ "${AUTOSYNC}" == "true" ]]
then
    echo "${CRON_TIME} vdirsyncer -c ${VDIRSYNCER_CONFIG} metasync && vdirsyncer -c ${VDIRSYNCER_CONFIG} sync" >> /etc/crontabs/"${VDIRSYNCER_USER}"
    echo 'Only Autosync is enabled.' 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"
    exec crond -l 8 -d 8 -f 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"

# Append to crontab file if autodiscover is true
elif [[ "${AUTODISCOVER}" == "true" ]] && [[ "${AUTOSYNC}" == "false" ]]
then
    echo "${CRON_TIME} yes | vdirsyncer -c ${VDIRSYNCER_CONFIG} discover" >> /etc/crontabs/"${VDIRSYNCER_USER}"
    echo 'Only Autodiscover is enabled.' 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"
    exec crond -l 8 -d 8 -f 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"

# Append nothing, if both options are disabled
else
    echo 'Autodiscover and Autosync are disabled.' 2>&1 | ts '[[%Y-%m-%d %H:%M:%S]]' | tee -a "${LOG}"
fi

# Run Container
exec tail -f /dev/null

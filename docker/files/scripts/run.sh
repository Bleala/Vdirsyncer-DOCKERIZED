#!/bin/bash
sudo chmod -R +x /files/scripts \
    && sudo chown -R vdirsyncer:vdirsyncer /files \
    && sudo chown -R vdirsyncer:vdirsyncer /vdirsyncer \
    && sudo chmod -R 755 /vdirsyncer \
    && sudo chown vdirsyncer:vdirsyncer "${CRON_FILE}" \
    && sudo chmod 644 "${CRON_FILE}" \
    && sudo chown -R "${VDIRSYNCER_USER}":"${VDIRSYNCER_USER}" "${PIPX_HOME}"

# Check if a logfile exists
if [[ -e "${LOG}" ]]
then
    # Delete old logfiles
    rm -f "${LOG}" > /dev/null 2>&1

    # Save exit code
    LOG_FILE_DELETED="${?}"

    # Check if old Log File has been deleted
    if [[ "${LOG_FILE_DELETED}" -ne 0 ]]
    then
        # User info
        {
            echo "Old log file could not be deleted!"
            echo "Check the \"LOG\" environment variable or the file permissions of the old logfile (maybe delete it manually)."
            echo "Container exits!"
        } 2>&1 | ts '[%Y-%m-%d %H:%M:%S]'

        # Exit Container
        exit 1
    fi
fi

# Create Log File
/usr/bin/curl --create-dirs --output "${LOG}" file:///dev/null > /dev/null 2>&1

# Save exit code
LOG_FILE_CREATED="${?}"

# Check if Log File has been created
if [[ "${LOG_FILE_CREATED}" -ne 0 ]]
then
    # User info
    {
        echo "Log file (\"${LOG}\") could not be created!"
        echo "Check the \"LOG\" environment variable or the folder permissions."
        echo "Container exits!"
    } 2>&1 | ts '[%Y-%m-%d %H:%M:%S]'

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
} 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

# Starting logging
{
    echo "Starting Logging..."
    printf "\n"
} 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

# Hint if the old logfile has been deleted
if [[ "${LOG_FILE_DELETED}" -eq 0 ]]
then
    # User info
    {
        echo "Old log file has been deleted."
        printf "\n"
    } 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
fi

# Hint if the logfile has been created
if [[ "${LOG_FILE_CREATED}" -eq 0 ]]
then
    # User info
    {
        echo "New log file (\"${LOG}\") has been created."
        printf "\n"
    } 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
fi

# Log current Timezone and Date/Time
{
    echo "Current timezone is ${TZ}."
    echo "Current time is $(date)."
    printf "\n"
} 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

# Log current CRON_TIME
{
    echo "Current CRON_TIME is ${CRON_TIME}."
    printf "\n"
} 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

# Check if the config.example exists
if [[ ! -e "/vdirsyncer/config.example" ]]
then
    # Copy config.example to vdirsyncer directory
    cp /files/examples/config.example /vdirsyncer/config.example
    # User info
    {
        echo "config.example has been copied to /vdirsyncer."
        printf "\n"
    } 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
fi

# Check if Autoupdate is enabled
if [[ "${AUTOUPDATE}" == "true" ]]
then
    {
        # User info
        echo "#######################################"
        printf "\n"
        echo "Autoupdate of Vdirsyncer is enabled."
        echo "Starting update..."
        printf "\n"

        # Vdirsyncer update
        PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx upgrade --include-injected vdirsyncer

        # Save exit code of update
        UPDATE_SUCCESSFUL="${?}"

        # Check if update was successful
        if [[ "${UPDATE_SUCCESSFUL}" -eq 0 ]]
        then
            # User info
            printf "\n"
            echo "Vdirsyncer update was successful."
        else
            # User info
            printf "\n"
            echo "Vdirsyncer update FAILED!"
        fi
        
        # End of update
        printf "\n"
        echo "#######################################"
        printf "\n"
    } 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
fi

# Check, if PRE_SYNC_SCRIPT_FILE is set
if [ -z "${PRE_SYNC_SCRIPT_FILE}" ]
then
    # Set Post Sync Snippet to nothing
    PRE_SYNC_SNIPPET=""

# Set PRE_SYNC_SNIPPET, if  POST_SYNC_SCRIPT_FILE is set
else
    # User info
    {
        echo "Custom scripts are enabled."
        printf "\n"
    } 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

    # Set Post Sync Snippet to Post Sync File
    PRE_SYNC_SNIPPET="${PRE_SYNC_SCRIPT_FILE} &&"
fi


# Check, if POST_SYNC_SCRIPT_FILE is set
if [ -z "${POST_SYNC_SCRIPT_FILE}" ]
then
    # Set Post Sync Snippet to nothing
    POST_SYNC_SNIPPET=""

# Set POST_SYNC_SNIPPET, if  POST_SYNC_SCRIPT_FILE is set
else
    # User info
    {
        echo "Custom scripts are enabled."
        printf "\n"
    } 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

    # Set Post Sync Snippet to Post Sync File
    POST_SYNC_SNIPPET="&& ${POST_SYNC_SCRIPT_FILE}"
fi

### Set up Cronjobs ###
# Append to crontab file if autodiscover and autosync are true
if [[ "${AUTODISCOVER}" == "true" ]] && [[ "${AUTOSYNC}" == "true" ]]
then
    # Write cronjob to file
    echo "${CRON_TIME} yes | ${PRE_SYNC_SNIPPET} /usr/local/bin/vdirsyncer -c ${VDIRSYNCER_CONFIG} discover \
    && /usr/local/bin/vdirsyncer -c ${VDIRSYNCER_CONFIG} metasync \
    && /usr/local/bin/vdirsyncer -c ${VDIRSYNCER_CONFIG} sync ${POST_SYNC_SNIPPET}" > "${CRON_FILE}"

    # User info
    echo 'Autodiscover and Autosync are enabled.' 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

    # Check if LOG_LEVEL environment variable is empty
    if [[ -z "${LOG_LEVEL}" ]]
    then
        # Start the cronjob
        /usr/bin/supercronic "${CRON_FILE}" 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

    # If LOG_LEVEL environment variable is set
    else
        # Start the cronjob
        /usr/bin/supercronic "${LOG_LEVEL}" "${CRON_FILE}" 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
    fi

# Append to crontab file if autosync is true
elif [[ "${AUTODISCOVER}" == "false" ]] && [[ "${AUTOSYNC}" == "true" ]]
then
    # Write cronjob to file
    echo "${CRON_TIME} ${PRE_SYNC_SNIPPET} /usr/local/bin/vdirsyncer -c ${VDIRSYNCER_CONFIG} metasync \
    && /usr/local/bin/vdirsyncer -c ${VDIRSYNCER_CONFIG} sync ${POST_SYNC_SNIPPET}" > "${CRON_FILE}"

    # User info
    echo 'Only Autosync is enabled.' 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

    # Check if LOG_LEVEL environment variable is empty
    if [[ -z "${LOG_LEVEL}" ]]
    then
        # Start the cronjob
        /usr/bin/supercronic "${CRON_FILE}" 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

    # If LOG_LEVEL environment variable is set
    else
        # Start the cronjob
        /usr/bin/supercronic "${LOG_LEVEL}" "${CRON_FILE}" 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
    fi

# Append to crontab file if autodiscover is true
elif [[ "${AUTODISCOVER}" == "true" ]] && [[ "${AUTOSYNC}" == "false" ]]
then
    # Write cronjob to file
    echo "${CRON_TIME} yes | ${PRE_SYNC_SNIPPET} /usr/local/bin/vdirsyncer -c ${VDIRSYNCER_CONFIG} discover ${POST_SYNC_SNIPPET}" > "${CRON_FILE}"

    # User info
    echo 'Only Autodiscover is enabled.' 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

    # Check if LOG_LEVEL environment variable is empty
    if [[ -z "${LOG_LEVEL}" ]]
    then
        # Start the cronjob
        /usr/bin/supercronic "${CRON_FILE}" 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"

    # If LOG_LEVEL environment variable is set
    else
        # Start the cronjob
        /usr/bin/supercronic "${LOG_LEVEL}" "${CRON_FILE}" 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
    fi

# Append nothing, if both options are disabled
else
    echo 'Autodiscover and Autosync are disabled.' 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "${LOG}"
fi

id vdirsyncer
echo "UID: ${UID}"
touch /tmp/testfile

# Run Container
exec tail -f /dev/null

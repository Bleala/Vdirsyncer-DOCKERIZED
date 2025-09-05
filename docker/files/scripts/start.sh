#!/bin/sh

# Function to log messages with timestamp, reduce code duplication
log_message() {
    {
        # Remove tabs and leading spaces from the message
        printf "%s\n" "$@" | sed 's/^[ \t]*//'
        printf "\n"
    }
}

# Line
log_message "----------------------------------------"

# Welcome Message
log_message "Welcome to Vdirsyncer DOCKERIZED! :)"

log_message "For more information please visit the official docs page.
            There you will also find configuration examples.
            https://vdirsyncer.pimutils.org/en/stable/index.html"

log_message "If you have any problems with Vdirsyncer, please
            visit the Github repo and open an issue.
            https://github.com/pimutils/vdirsyncer"

log_message "If there is a problem with the container,
            contact me or open an issue in my Github repo.
            https://github.com/Bleala/Vdirsyncer-DOCKERIZED
            I am trying to fix it, so that everything
            is running as expected. :)"

log_message "Enjoy!"

# Line
log_message "----------------------------------------"

# Starting logging
log_message "Starting Logging."

# Log current Timezone
log_message "Current timezone is ${TZ}."

# Log current Date/Time
log_message "Current time is $(date)."

# Log current CRON_TIME
log_message "Current CRON_TIME is ${CRON_TIME}."

# Log current LOG_LEVEL
log_message "Current LOG_LEVEL is ${LOG_LEVEL}."

# Check, if POST_SYNC_SCRIPT_FILE is set
if [ -z "${POST_SYNC_SCRIPT_FILE}" ]
then
    # Set Post Sync Snippet to nothing
    POST_SYNC_SNIPPET=""

# Set POST_SYNC_SNIPPET, if  POST_SYNC_SCRIPT_FILE is set
else
    # User info
    log_message "Custom after script is enabled."

    # Log current POST_SYNC_SCRIPT_FILE
    log_message "Current POST_SYNC_SCRIPT_FILE is ${POST_SYNC_SCRIPT_FILE}."

    # Set Post Sync Snippet to Post Sync File
    POST_SYNC_SNIPPET="&& ${POST_SYNC_SCRIPT_FILE}"
fi

# Check, if PRE_SYNC_SCRIPT_FILE is set
if [ -z "${PRE_SYNC_SCRIPT_FILE}" ]
then
    # Set Post Sync Snippet to nothing
    PRE_SYNC_SNIPPET=""

# Set PRE_SYNC_SNIPPET, if  PRE_SYNC_SCRIPT_FILE is set
else
    # User info
    log_message "Custom before script is enabled."

    # Log current PRE_SYNC_SCRIPT_FILE
    log_message "Current PRE_SYNC_SCRIPT_FILE is ${PRE_SYNC_SCRIPT_FILE}."

    # Set Post Sync Snippet to Post Sync File
    PRE_SYNC_SNIPPET="${PRE_SYNC_SCRIPT_FILE} &&"
fi

# Log current VDIRSYNCER_CONFIG
log_message "Current VDIRSYNCER_CONFIG is ${VDIRSYNCER_CONFIG}."

# Check, if VDIRSYNCER_SYNC_FLAGS are set
if [ -z "${VDIRSYNCER_SYNC_FLAGS}" ]
then
    # User info
    log_message "\"vdirsyncer sync\" flags are not enabled."

else
    # User info
    log_message "\"vdirsyncer sync\" flags are enabled."

    # Log current VDIRSYNCER_SYNC_FLAGS
    log_message "Current VDIRSYNCER_SYNC_FLAGS are ${VDIRSYNCER_SYNC_FLAGS}."    
fi

# Check if the config.example exists
if [ ! -e "/vdirsyncer/config.example" ]
then
    # Copy config.example to vdirsyncer directory
    cp /files/examples/config.example /vdirsyncer/config.example
    # User info
    log_message "config.example has been copied to /vdirsyncer/config.example."
fi

# Line
log_message "----------------------------------------"

# Check if Autoupdate is enabled
if [ "${AUTOUPDATE}" = "true" ]
then
    # User info
    log_message "Autoupdate of Vdirsyncer is enabled.
                Starting update."

    # Vdirsyncer update
    PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx upgrade --include-injected vdirsyncer

    # Save exit code of update
    UPDATE_SUCCESSFUL="${?}"

    # Linebreak
    printf "\n"

    # Check if update was successful
    if [ "${UPDATE_SUCCESSFUL}" -eq 0 ]
    then
        # User info
        log_message "Vdirsyncer update was successful."
    else
        # User info
        log_message "Vdirsyncer update FAILED!"
    fi
fi

# Line
log_message "----------------------------------------"

### Set up Cronjobs ###
# Append to crontab file if autodiscover and autosync are true
if [ "${AUTODISCOVER}" = "true" ] && [ "${AUTOSYNC}" = "true" ]
then
    # Write cronjob to file
    echo "${CRON_TIME} yes | ${PRE_SYNC_SNIPPET} /usr/local/bin/vdirsyncer -c ${VDIRSYNCER_CONFIG} discover \
    && /usr/local/bin/vdirsyncer -c ${VDIRSYNCER_CONFIG} metasync \
    && /usr/local/bin/vdirsyncer -c ${VDIRSYNCER_CONFIG} sync ${VDIRSYNCER_SYNC_FLAGS} ${POST_SYNC_SNIPPET}" > "${CRON_FILE}"

    # User info
    log_message "Autodiscover and Autosync are enabled."

    # Check if LOG_LEVEL environment variable is empty
    if [ -z "${LOG_LEVEL}" ]
    then
        # Start the cronjob
        exec "${SUPERCRONIC_EXECUTABLE_PATH}" "${CRON_FILE}"

    # If LOG_LEVEL environment variable is set
    else
        # Start the cronjob
        exec "${SUPERCRONIC_EXECUTABLE_PATH}" "${LOG_LEVEL}" "${CRON_FILE}"
    fi

# Append to crontab file if autosync is true
elif [ "${AUTODISCOVER}" = "false" ] && [ "${AUTOSYNC}" = "true" ]
then
    # Write cronjob to file
    echo "${CRON_TIME} ${PRE_SYNC_SNIPPET} /usr/local/bin/vdirsyncer -c ${VDIRSYNCER_CONFIG} metasync \
    && /usr/local/bin/vdirsyncer -c ${VDIRSYNCER_CONFIG} sync ${VDIRSYNCER_SYNC_FLAGS} ${POST_SYNC_SNIPPET}" > "${CRON_FILE}"

    # User info
    log_message "Only Autosync is enabled."

    # Check if LOG_LEVEL environment variable is empty
    if [ -z "${LOG_LEVEL}" ]
    then
        # Start the cronjob
        exec "${SUPERCRONIC_EXECUTABLE_PATH}" "${CRON_FILE}"

    # If LOG_LEVEL environment variable is set
    else
        # Start the cronjob
        exec "${SUPERCRONIC_EXECUTABLE_PATH}" "${LOG_LEVEL}" "${CRON_FILE}"
    fi

# Append to crontab file if autodiscover is true
elif [ "${AUTODISCOVER}" = "true" ] && [ "${AUTOSYNC}" = "false" ]
then
    # Write cronjob to file
    echo "${CRON_TIME} yes | ${PRE_SYNC_SNIPPET} /usr/local/bin/vdirsyncer -c ${VDIRSYNCER_CONFIG} discover ${POST_SYNC_SNIPPET}" > "${CRON_FILE}"

    # User info
    log_message "Only Autodiscover is enabled."

    # Check if LOG_LEVEL environment variable is empty
    if [ -z "${LOG_LEVEL}" ]
    then
        # Start the cronjob
        exec "${SUPERCRONIC_EXECUTABLE_PATH}" "${CRON_FILE}"

    # If LOG_LEVEL environment variable is set
    else
        # Start the cronjob
        exec "${SUPERCRONIC_EXECUTABLE_PATH}" "${LOG_LEVEL}" "${CRON_FILE}"
    fi

# Append nothing, if both options are disabled
else
    # User Info
    log_message "Autodiscover and Autosync are disabled."

    # Run Container
    exec tail -f /dev/null
fi

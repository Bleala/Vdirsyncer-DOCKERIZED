#!/bin/sh
set -e

# Überprüft, ob der supercronic-Prozess mit der CRON_FILE Variable läuft
if pgrep -f "${SUPERCRONIC_EXECUTABLE_PATH}.*${CRON_FILE}" > /dev/null 2>&1
then
  exit 0
else
  exit 1
fi
# Alpine Image
FROM alpine:3.22.1 AS vdirsyncer

# Build Arguments
ARG ALPINE_VERSION="3.22.1" \
    IMAGE_VERSION="2.6.0" \
    PYTHON_VERSION="3.12.11" \
    PIP_VERSION="25.2" \
    PIPX_VERSION="1.7.1" \
    VDIRSYNCER_VERSION="0.20.0"

# Set up Environment
    # Set Autodiscover
ENV AUTODISCOVER=false \
    # Set Autosync
    AUTOSYNC=false \
    # Set Autoupdate
    AUTOUPDATE=false \
    # Set cron file
    CRON_FILE="/etc/crontabs/vdirsyncer" \
    # Set Cron Time
    CRON_TIME='*/15 * * * *' \
    # Set GID
    GID="1000" \
    # Supercronic log level
    LOG_LEVEL="" \
    # Set Pipx bin dir
    PIPX_BIN_DIR="/usr/local/bin" \
    # Set Pipx home
    PIPX_HOME="/opt/pipx" \
    # Set script path to run after vdirsyncer commands
    POST_SYNC_SCRIPT_FILE="" \
    # Set script path to run before vdirsyncer commands
    PRE_SYNC_SCRIPT_FILE="" \
    # Sleep Path
    SLEEP_EXECUTABLE_PATH="/bin/sleep" \
    # Supercronic Path
    SUPERCRONIC_EXECUTABLE_PATH="/usr/bin/supercronic" \
    # Tini Path
    TINI_EXECUTABLE_PATH="/sbin/tini" \
    # Set Timezone
    TZ="Europe/Vienna" \
    # Set UID
    UID="1000" \
    # Set Vdirsyncer config location
    VDIRSYNCER_CONFIG="/vdirsyncer/config" \
    # Vdirsyncer Path
    VDIRSYNCER_EXECUTABLE_PATH="/usr/local/bin/vdirsyncer" \
    # Set Vdirsyncer user
    VDIRSYNCER_USER="vdirsyncer" \
    # Vdirsyncer sync flags
    VDIRSYNCER_SYNC_FLAGS=""

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=1 \
  CMD ["/files/scripts/healthcheck.sh"]

# Install packages and dependencies
RUN apk update && \
    apk add --no-cache \
        # For Scripts and Shell
        bash=~5.2.37 \
        # Curl, for Google Auth (https://github.com/pimutils/vdirsyncer/issues/1063#issuecomment-1910758500)
        curl=~8.14.1 \
        # File Command (Issue #40)
        file=~5.46 \
        # Install Python/Pip
        py3-pip=~25.1.1 \
        # Supercronic instead of Cron (for cronjobs)
        supercronic=~0.2.33 \
        # For Timezone
        tzdata=~2025b \
        # Tini as a minimal init system to handle signal processing (for manual mode)
        tini=~0.19.0 && \
    # Update Pip
    pip install --upgrade --no-cache-dir --break-system-packages pip=="${PIP_VERSION}" && \
    # Install Pipx
    pip install --upgrade --no-cache-dir --break-system-packages pipx=="${PIPX_VERSION}"

# Set up User and Group
RUN addgroup -g "${GID}" "${VDIRSYNCER_USER}" && \
    # Set up User
    adduser \
    -D \
    # Add to Group
    -G "${VDIRSYNCER_USER}" \
    # Home directory
    -h "/home/${VDIRSYNCER_USER}" \
    # Set UID
    -u "${UID}" \
    # Set Username
    "${VDIRSYNCER_USER}" && \
    # Set up Crontab file
    touch "${CRON_FILE}"

# Vdirsyncer installation
RUN PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx install "vdirsyncer==${VDIRSYNCER_VERSION}" && \
    # Install dependencies
    PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx inject vdirsyncer aiohttp-oauthlib && \
    PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx inject vdirsyncer "vdirsyncer[google]" && \
    # Update Path for Pipx
    PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx ensurepath

# Set up Workdir
WORKDIR /vdirsyncer

# Copy Files
COPY files /files/

# Change Permissions
RUN chmod -R +x /files/scripts && \
    chown -R "${UID}":"${GID}" /files && \
    chown -R "${UID}":"${GID}" /vdirsyncer && \
    chmod -R 755 /vdirsyncer && \
    chown "${UID}":"${GID}" "${CRON_FILE}" && \
    chmod 666 "${CRON_FILE}" && \
    chown -R "${VDIRSYNCER_USER}":"${VDIRSYNCER_USER}" "${PIPX_HOME}"

# Set build date argument here, because caching would break otherwise
# It is set during the build process in the reusable workflow
ARG BUILD_DATE

# Set labels
LABEL org.opencontainers.image.authors="Bleala" \
      org.opencontainers.image.vendor="Bleala" \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.title="Vdirsyncer-DOCKERIZED" \
      org.opencontainers.image.description="Vdirsyncer - sync calendars and addressbooks between servers and the local filesystem. DOCKERIZED!" \
      org.opencontainers.image.documentation="https://vdirsyncer.pimutils.org/en/stable/index.html" \
      org.opencontainers.image.url="https://hub.docker.com/r/bleala/vdirsyncer" \
      org.opencontainers.image.source="https://github.com/Bleala/Vdirsyncer-DOCKERIZED"

# Switch User
USER "${VDIRSYNCER_USER}"

# Entrypoint
ENTRYPOINT ["/bin/sh","/files/scripts/start.sh"]

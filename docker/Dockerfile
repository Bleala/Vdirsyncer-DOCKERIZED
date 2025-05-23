# Alpine Image
FROM alpine:3.21.3

# Build Arguments
ARG ALPINE_VERSION="3.21.3" \
        IMAGE_VERSION="2.5.7" \
        PIP_VERSION="25.1.1" \
        PIPX_VERSION="1.7.1" \
        PYTHON_VERSION="3.12.10" \
        PYTHON_VERSION_SHORT="3.12" \
        VDIRSYNCER_VERSION="0.19.3"

# Set up Environment
    # Set Vdirsyncer config location
ENV VDIRSYNCER_CONFIG="/vdirsyncer/config" \
        # Set log file
        LOG="/vdirsyncer/vdirsyncer.log" \
        # Set Autodiscover
        AUTODISCOVER=false \
        # Set Autosync
        AUTOSYNC=false \
        # Set Autoupdate
        AUTOUPDATE=false \
        # Set Cron Time
        CRON_TIME='*/15 * * * *' \
        # Set Timezone
        TZ="Europe/Vienna" \
        # Set UID
        UID="1000" \
        # Set GID
        GID="1000" \
        # Set Vdirsyncer user
        VDIRSYNCER_USER="vdirsyncer" \
        # Set cron file
        CRON_FILE="/etc/crontabs/vdirsyncer" \
        # Set script path to run before vdirsyncer commands
        PRE_SYNC_SCRIPT_FILE="" \
        # Set script path to run after vdirsyncer commands
        POST_SYNC_SCRIPT_FILE="" \
        # Set Pipx home
        PIPX_HOME="/opt/pipx" \
        # Set Pipx bin dir
        PIPX_BIN_DIR="/usr/local/bin" \
        # Supercronic log level
        LOG_LEVEL=""

# Install packages and dependencies
RUN apk add --no-cache apk-tools=~2.14.6 \
        # Install Pip
        && apk add --no-cache py3-pip=~24.3.1 \
        # Update Pip
        && pip install --upgrade --no-cache-dir --break-system-packages pip==25.1.1 \
        # Install Pipx
        && pip install --upgrade --no-cache-dir --break-system-packages pipx==1.7.1 \
        # For Curl Commands
        && apk add --no-cache curl=~8.12.1 \                    
        # For TS
        && apk add --no-cache moreutils=~0.69 \               
        # For Timezone
        && apk add --no-cache tzdata=~2025b \                  
        # For Sudo Commands
        #&& apk add --no-cache sudo \                    
        # For Usermod                                
        #&& apk add --no-cache shadow \
        # For Scripts and Shell
        && apk add --no-cache bash=~5.2.37 \
        # Nano Editor
        && apk add --no-cache nano=~8.2 \
        # Cron Update
        #&& apk add --no-cache busybox-suid \
        # Supercronic instead of Cron (for cronjobs)
        && apk add --no-cache supercronic=~0.2.33

# Set up User and Group
RUN addgroup -g "${GID}" "${VDIRSYNCER_USER}" \
        # Set up User
        && adduser \
        -D \
        # Add to Group
        -G "${VDIRSYNCER_USER}" \
        # Don't create home directory
        #-H \
        # Home directory
        -h "/home/${VDIRSYNCER_USER}" \
        # Set UID
        -u "${UID}" \
        # Set Username
        "${VDIRSYNCER_USER}" \
        # Remove root password
        #&& passwd -d root \
        # Set up Crontab file
        && touch "${CRON_FILE}"

# Full sudo access for vdirsyncer user
# RUN echo "vdirsyncer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/vdirsyncer

# Set up Workdir
WORKDIR /vdirsyncer

# Copy Files
COPY files /files/

# Set up Timezone
RUN cp "/usr/share/zoneinfo/${TZ}" /etc/localtime \
        && echo "${TZ}" > /etc/timezone

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=1 \
  CMD ps -ef | grep -e "supercronic" | grep -v -e "grep" || exit 1

# Labeling
LABEL maintainer="Bleala" \
        version="${IMAGE_VERSION}" \
        description="Vdirsyncer ${VDIRSYNCER_VERSION} on Alpine ${ALPINE_VERSION}, Pip ${PIP_VERSION}, Pipx ${PIPX_VERSION}, Python ${PYTHON_VERSION}" \
        org.opencontainers.image.source="https://github.com/Bleala/Vdirsyncer-DOCKERIZED" \
        org.opencontainers.image.url="https://github.com/Bleala/Vdirsyncer-DOCKERIZED"

# Vdirsyncer installation
RUN PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx install "vdirsyncer==${VDIRSYNCER_VERSION}" \
        # For Vdirsyncer 0.19.x (Pipx install)
        && PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx inject vdirsyncer aiohttp-oauthlib \
        && PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx inject vdirsyncer "vdirsyncer[google]" \
        # Update Path for Pipx
        && PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx ensurepath

# Change Permissions
RUN chmod -R +x /files/scripts \
        && chown -R "${UID}":"${GID}" /files \
        && chown -R "${UID}":"${GID}" /vdirsyncer \
        && chmod -R 755 /vdirsyncer \
        && chown "${UID}":"${GID}" "${CRON_FILE}" \
        && chmod 666 "${CRON_FILE}" \
        && chown -R "${VDIRSYNCER_USER}":"${VDIRSYNCER_USER}" "${PIPX_HOME}"

# Switch User
USER "${VDIRSYNCER_USER}"

# Entrypoint
ENTRYPOINT ["bash","/files/scripts/start.sh"]

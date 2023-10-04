# Alpine Image
FROM alpine:3.18.3

# Build Arguments
ARG ALPINE_VERSION="3.18.3" \
        IMAGE_VERSION="2.5.0" \
        PIP_VERSION="23.2.1" \
        PIPX_VERSION="1.2.0" \
        PYTHON_VERSION="3.11.5" \
        PYTHON_VERSION_SHORT="3.11" \
        VDIRSYNCER_VERSION="0.19.2"

# Set up Environment
    # Set Vdirsyncer config location
ENV VDIRSYNCER_CONFIG=/vdirsyncer/config \
        # Set log file
        LOG=/vdirsyncer/vdirsyncer.log \
        # Set Autodiscover
        AUTODISCOVER=false \
        # Set Autosync
        AUTOSYNC=false \
        # Set Autoupdate
        AUTOUPDATE=false \
        # Set Cron Time
        CRON_TIME='*/15 * * * *' \
        # Set Timezone
        TZ=Europe/Vienna \
        # Set UID
        UID="1000" \
        # Set GID
        GID="1000" \
        # Set Vdirsyncer user
        VDIRSYNCER_USER="vdirsyncer" \
        # Set cron file
        CRON_FILE="/etc/crontabs/vdirsyncer" \
        # Script to run after sync complete
        POST_SYNC_SCRIPT_FILE= \
        # Set Pipx home
        PIPX_HOME="/opt/pipx" \
        # Set Pipx bin dir
        PIPX_BIN_DIR="/usr/local/bin" \
        # Supercronic log level
        LOG_LEVEL=

# Update and install packages
RUN apk update \
        && apk add --no-cache --upgrade apk-tools \
        && apk upgrade --no-cache --available \
        # Install Pip
        && apk add --no-cache py3-pip \
        # Update Pip
        && pip install --upgrade pip \
        # Install Pipx
        && pip install pipx \
        # For Curl Commands
        && apk add --no-cache curl \                    
        # For TS
        && apk add --no-cache moreutils \               
        # For Timezone
        && apk add --no-cache tzdata \                  
        # For Sudo Commands
        #&& apk add --no-cache sudo \                    
        # For Usermod                                
        #&& apk add --no-cache shadow \
        # For Scripts and Shell
        && apk add --no-cache bash \
        # Nano Editor
        && apk add --no-cache nano \
        # Cron Update
        #&& apk add --update busybox-suid \
        # Supercronic instead of Cron (for cronjobs)
        && apk add --no-cache supercronic 

# Set up User
    # Set up Group
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
#RUN echo "vdirsyncer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/vdirsyncer

# Set up Workdir
WORKDIR /vdirsyncer

# Add Files
ADD files /files/

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
        # For Vdirsyncer 0.18.0
        #&& pip install requests-oauthlib
        # For Vdirsyncer 0.19.x (Pip install)
        #&& pip install aiohttp-oauthlib \
        #&& pip install vdirsyncer[google] \
        # For Vdirsyncer 0.19.x (Pipx install)
        && PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx inject vdirsyncer aiohttp-oauthlib \
        && PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx inject vdirsyncer vdirsyncer[google] \
        # Update Path for Pipx
        && PIPX_HOME="${PIPX_HOME}" PIPX_BIN_DIR="${PIPX_BIN_DIR}" pipx ensurepath


# Fix Google redirect uri
# For Vdirsyncer 0.19.1 (Pip Install) 
#RUN sed -i 's~f"http://{host}:{local_server.server_port}"~"http://127.0.0.1:8088"~g' /home/vdirsyncer/.local/lib/python3.10/site-packages/vdirsyncer/storage/google.py
# For Vdirsyncer 0.19.1 (Pipx Install) 
#RUN sed -i 's~f"http://{host}:{local_server.server_port}"~"http://127.0.0.1:8088"~g' "/home/${VDIRSYNCER_USER}/.local/pipx/venvs/vdirsyncer/lib/python3.11/site-packages/vdirsyncer/storage/google.py"
# For Vdirsyncer 0.19.1 (Pipx, Global Install) 
#RUN sed -i 's~f"http://{host}:{local_server.server_port}"~"http://127.0.0.1:8088"~g' "${PIPX_HOME}/venvs/vdirsyncer/lib/python${PYTHON_VERSION_SHORT}/site-packages/vdirsyncer/storage/google.py"
#For Vdirsyncer 0.18.0 - User install
#RUN sed -i 's~urn:ietf:wg:oauth:2.0:oob~http://127.0.0.1:8088~g' /home/vdirsyncer/.local/lib/python3.10/site-packages/vdirsyncer/storage/google.py
#For Vdirsyncer 0.18.0 - Root install
#RUN sed -i 's~urn:ietf:wg:oauth:2.0:oob~http://127.0.0.1:8088~g' /usr/lib/python3.10/site-packages/vdirsyncer/storage/google.py

# Change Permissions
RUN chmod -R +x /files/scripts \
        && chown -R "${UID}":"${GID}" /files \
        && chown -R "${UID}":"${GID}" /vdirsyncer \
        && chmod -R 755 /vdirsyncer \
        && chown "${UID}":"${GID}" "${CRON_FILE}" \
        && chmod 644 "${CRON_FILE}" \
        && chown -R "${VDIRSYNCER_USER}":"${VDIRSYNCER_USER}" "${PIPX_HOME}"

# Switch User
USER "${VDIRSYNCER_USER}"

# Entrypoint
ENTRYPOINT ["bash","/files/scripts/start.sh"]

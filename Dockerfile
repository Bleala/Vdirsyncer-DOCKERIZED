# Alpine Image
FROM alpine:3.17.3

# Build Arguments
ARG ALPINE_VERSION="3.17.3" \
        IMAGE_VERSION="2.4.0" \
        PIP_VERSION="23.1.2" \
        PIPX_VERSION="1.2.0" \
        PYTHON_VERSION="3.10.11" \
        VDIRSYNCER_VERSION="0.19.1" \
        VDIRSYNCER_USER="vdirsyncer" \
        UID="1000" \
        GID="1000"

# Set up Environment
    # Set Vdirsyncer config location
ENV VDIRSYNCER_CONFIG=/vdirsyncer/config \
        # Update Path for sh Shell (ensurepath only works for Bash Shell somehow)
        PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/vdirsyncer/.local/bin \
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
        UID="${UID}" \
        # Set GID
        GID="${GID}" \
        # Set Vdirsyncer user again as environment variable
        VDIRSYNCER_USER="${VDIRSYNCER_USER}"

# Update and install packages
RUN apk update \
        && apk add --no-cache --upgrade apk-tools \
        && apk upgrade --no-cache --available \
        # Install Pip
        && apk add --no-cache py3-pip \
        # Update Pip
        && pip install --upgrade pip \
        # Install Pipx
        pip install pipx \
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
        && apk add --no-cache nano

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
        && cp /etc/crontabs/root "/etc/crontabs/${VDIRSYNCER_USER}"

# Set up Workdir
WORKDIR /vdirsyncer

# Add Files
ADD files /files/

# Set up Timezone
RUN cp /usr/share/zoneinfo/"${TZ}" /etc/localtime \
        && echo "${TZ}" > /etc/timezone

# Healthcheck
HEALTHCHECK --interval=1m --timeout=10s --start-period=1s --retries=3 \
  CMD sudo ping -c 3 localhost || exit 1

# Labeling
LABEL maintainer="Bleala" \
        version="${IMAGE_VERSION}" \
        description="Vdirsyncer ${VDIRSYNCER_VERSION} on Alpine ${ALPINE_VERSION}, Pip ${PIP_VERSION}, Pipx ${PIPX_VERSION}, Python ${PYTHON_VERSION}" \
        org.opencontainers.image.source="https://github.com/Bleala/Vdirsyncer-DOCKERIZED"

# Change Permissions
RUN chmod -R +x /files/scripts \
        && chmod -R +r /files \
        && chown -R "${UID}":"${GID}" /files \
        && chown -R "${UID}":"${GID}" /vdirsyncer \
        && chown -R "${UID}":"${GID}" /etc/crontabs/"${VDIRSYNCER_USER}" \
        && chmod -R 755 /vdirsyncer

# Switch User
USER "${VDIRSYNCER_USER}"

# Vdirsyncer installation
RUN pipx install "vdirsyncer==${VDIRSYNCER_VERSION}" \
        # For Vdirsyncer 0.18.0
        #&& pip install requests-oauthlib
        # For Vdirsyncer 0.19.x (Pip install)
        #&& pip install aiohttp-oauthlib \
        #&& pip install vdirsyncer[google] \
        # For Vdirsyncer 0.19.x (Pipx install)
        && pipx inject vdirsyncer aiohttp-oauthlib \
        && pipx inject vdirsyncer vdirsyncer[google] \
        # Update Path for Pipx
        && pipx ensurepath

# Fix Google redirect uri
# For Vdirsyncer 0.19.1 (Pip Install) 
#RUN sed -i 's~f"http://{host}:{local_server.server_port}"~"http://127.0.0.1:8088"~g' /home/vdirsyncer/.local/lib/python3.10/site-packages/vdirsyncer/storage/google.py
# For Vdirsyncer 0.19.1 (Pipx Install) 
RUN sed -i 's~f"http://{host}:{local_server.server_port}"~"http://127.0.0.1:8088"~g' "/home/${VDIRSYNCER_USER}/.local/pipx/venvs/vdirsyncer/lib/python3.10/site-packages/vdirsyncer/storage/google.py"
#For Vdirsyncer 0.18.0 - User install
#RUN sed -i 's~urn:ietf:wg:oauth:2.0:oob~http://127.0.0.1:8088~g' /home/vdirsyncer/.local/lib/python3.10/site-packages/vdirsyncer/storage/google.py
#For Vdirsyncer 0.18.0 - Root install
#RUN sed -i 's~urn:ietf:wg:oauth:2.0:oob~http://127.0.0.1:8088~g' /usr/lib/python3.10/site-packages/vdirsyncer/storage/google.py

# Entrypoint
ENTRYPOINT ["bash","/files/scripts/start.sh"]

# Alpine Image
FROM alpine:3.15

# Update and install pip3
RUN apk update \
        && apk add --no-cache --upgrade apk-tools \
        && apk upgrade --no-cache --available \
        && apk add --no-cache py3-pip \                 
        # For Vdirsyncer Dependencies
        && apk add --no-cache curl \                    
        # For Curl Commands
        && apk add --no-cache moreutils \               
        # For TS
        && apk add --no-cache tzdata \                  
        # For Timezone
        && apk add --no-cache sudo \                    
        # For Sudo Commands
        && apk add --no-cache shadow \                  
        # For Usermod                                
# Install Vdirsyncer with dependencies
        && pip3 install --ignore-installed vdirsyncer \
        && pip3 install --ignore-installed vdirsyncer[google] \
        && pip3 install requests-oauthlib

# Set up Vdirsyncer
WORKDIR /vdirsyncer
ADD examples /examples/
ADD examples/vdirsyncer.log /vdirsyncer/logs/
ADD examples/config.example /vdirsyncer/config.example
RUN cp /etc/crontabs/root /root/crontab

# Start Script
ADD scripts /scripts/

# Set up Environment
ENV VDIRSYNCER_CONFIG=/vdirsyncer/config \
        LOG=/vdirsyncer/logs/vdirsyncer.log \
        AUTODISCOVER=false \
        AUTOSYNC=false \
        CRON_TIME='*/15 * * * *' \
        TZ=Europe/Vienna \
        UID=1000 \
        # For if in start.sh
        INIT_UID=1000 \
        GID=1000 \
        # For if in start.sh        
        INIT_GID=1000 \
        # For easier maintenance
        USER=vdirsyncer

# Healthcheck
HEALTHCHECK --interval=1m --timeout=10s --start-period=1s --retries=3 \
  CMD sudo ping -c 3 localhost || exit 1

# Labeling
LABEL maintainer="Bleala" \
        version="2.3.0" \
        description="Vdirsyncer 0.18.0 on Alpine 3.15, Python 3.9.7, Pip 20.3.4" \
        org.opencontainers.image.source="https://github.com/Bleala/Vdirsyncer-DOCKERIZED"

# Set up User
RUN addgroup -g $GID $USER \
        && adduser \
        -D \
        -G $USER \
        -H \
        -h "/vdirsyncer" \
        -u $UID \
        $USER \
        # Remove root password
        && passwd -d root

# Set up Sudo User
RUN echo 'ALL ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
        && echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/wheel \
        # Add Vdirsyncer User to wheel Group
        && adduser $USER wheel

# Change Permissions
RUN chmod -R +x /scripts \
        && chown -R $UID:$GID /scripts \
        && chown -R $UID:$GID /vdirsyncer \
        && chown -R $UID:$GID /examples \
        && chmod -R 755 /vdirsyncer

# Switch User
USER $USER

# Entrypoint
ENTRYPOINT ["sh","/scripts/start.sh"]

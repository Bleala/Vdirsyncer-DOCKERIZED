# Alpine Image
FROM alpine:3.15

# Update and install pip3
RUN apk update \
        && apk add --no-cache --upgrade apk-tools \
        && apk upgrade --no-cache --available \
        && apk add --no-cache py3-pip \
        && apk add --no-cache curl \
        && apk add --no-cache moreutils \
        && apk add --no-cache tzdata \
# Install Vdirsyncer with dependencies
        && pip3 install --ignore-installed vdirsyncer \
        && pip3 install --ignore-installed vdirsyncer[google] \
        && pip3 install requests-oauthlib

# Set up Vdirsyncer
WORKDIR /vdirsyncer
ADD examples /examples/
ADD examples/vdirsyncer.log /vdirsyncer/logs/
RUN cp /etc/crontabs/root /root/crontab

# Set up Environment
ENV VDIRSYNCER_CONFIG=/vdirsyncer/config \
        LOG=/vdirsyncer/logs/vdirsyncer.log \
        AUTODISCOVER=false \
        AUTOSYNC=false \
        CRON_TIME='*/15 * * * *' \
        TZ=Europe/Vienna

# Healthcheck
HEALTHCHECK --interval=1m --timeout=10s --start-period=1s --retries=3 \
  CMD ping -c 3 localhost || exit 1

# Labeling
LABEL maintainer="Bleala" \
        version="2.2" \
        description="Vdirsyncer 0.18.0 on Alpine 3.15, Python 3.9.7, Pip 20.3.4" \
        org.opencontainers.image.source="https://github.com/Bleala/Vdirsyncer-DOCKERIZED"


# Start Script
ADD scripts /scripts/
RUN ["chmod", "-R", "+x", "/scripts/"]
ENTRYPOINT ["sh","/scripts/start.sh"]

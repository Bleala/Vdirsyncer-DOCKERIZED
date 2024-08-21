# [Vdirsyncer](https://vdirsyncer.pimutils.org/en/stable/index.html "Official Documentation")-DOCKERIZED

Vdirsyncer - sync calendars and addressbooks between servers and the local filesystem. DOCKERIZED! 

## About Vdirsyncer
**New in `2.4.1`:** A Vdirsyncer autoupdate function has been added! :) If you set `AUTOUPDATE` to `true` then `Vdirsyncer` will update itself including all dependencies at container startup.

Also you are not able to set your own `UID` and `GID` anymore and the default value for both is `1000`! I have done this, to drop the root and sudo privileges completely. You should use a docker volume and just mount the `config` file into the container, [check out the docker-compose.yml](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/blob/main/docker-compose.yml "docker compose.yml"), or when using bind mounts make sure that the folder is readable and writable!

I will no longer push the `linux/arm/v7` docker image to the registry, because almost no one used this one.

**Disclaimer:** I am just the maintainer of this docker container, I did not write the software. Visit the [Official Github Repository](https://github.com/pimutils/vdirsyncer "Vdirsyncer Github Repository") to thank the author(s)! :)

Vdirsyncer is a command-line tool for synchronizing calendars and addressbooks between a variety of servers and the local filesystem. The most popular usecase is to synchronize a server with a local folder and use a set of other programs to change the local events and contacts. Vdirsyncer can then synchronize those changes back to the server.

However, vdirsyncer is not limited to synchronizing between clients and servers. It can also be used to synchronize calendars and/or addressbooks between two servers directly.

It aims to be for calendars and contacts what [OfflineIMAP](https://github.com/OfflineIMAP/offlineimap "OfflineIMAP Github Repository") is for emails.

Vdirsyncer also support many different servers:
* Baikal
* DavMail (Exchange, Outlook)
* FastMail
* Google
* iCloud
* Mailcow (SOGo)
* NextCloud
* Radicale
* Xandikos

Official Github Repository - https://github.com/pimutils/vdirsyncer

Docs - https://vdirsyncer.pimutils.org/en/stable/tutorial.html

My Github Repository - https://github.com/Bleala/Vdirsyncer-DOCKERIZED

Docker Hub - https://hub.docker.com/r/bleala/vdirsyncer

---
## Image, Versions and Architecture

I built this image based on [Alpine Linux](https://hub.docker.com/_/alpine "Alpine Linux Image") and set up everything with python3, pip3 and pipx.

There will always be two different versions:

| Tag | Content |
| ------------- |:-------------:|
| Latest    | Contains the latest stable version |
| 2.x     | Contains the Vdirsyncer, Python and Alpine versions mentioned at the bottom of the page | 

There are also several platforms supported:

Platform:
* linux/amd64
* linux/arm64 

Deprecated:
* linux/arm/v7

---

## Usage

To start the container you can run `docker run -d -e AUTOSYNC=true -v /path/to/local/folder:/vdirsyncer bleala/vdirsyncer:latest`, but since docker compose is easier to maintain, I'll give you a valid docker compose example


```docker compose.yml
version: "3.9"

networks:                                 
  default:
    driver: bridge

volumes:
  vdirsyncer:
    name: vdirsyncer
    driver: local

services:
  # Vdirsyncer - sync calendars and address books between servers and the local filesystem. DOCKERIZED!
  # https://hub.docker.com/r/bleala/vdirsyncer
  app:
    image: bleala/vdirsyncer:latest
    container_name: vdirsyncer
    restart: unless-stopped
    networks:
      - default
    environment:
      - TZ= # set your timezone, for correct container and log time, default to Europe/Vienna
      - AUTODISCOVER= # set to true for automatic discover, default to false
      - AUTOSYNC= # set to true for automatic sync, default to false
      - AUTOUPDATE= # set to true for automatic Vdirsyncer and dependencies updates on container startup, default to false
      - CRON_TIME= # adjust autosync /-discover time, default to 15 minutes - */15 * * * * 
      # Cron Time need to be set in Cron format - look here for generator https://crontab.guru/
      # Set CRON_TIME like that --> */15 * * * *
      # Optional
      - POST_SYNC_SCRIPT_FILE= # optional,  set to script path to automatically run your custom script after the cronjob `vdirsyncer` command(s), default to nothing
      - LOG= # optional, default to /vdirsyncer/vdirsyncer.log
      - LOG_LEVEL= # optional, default is normal output from supercronic
    volumes:
      - vdirsyncer:/vdirsyncer              # Docker Volume
      - /path/to/config:/vdirsyncer/config  # Vdirsyncer Config
      # Optional
      - /path/to/custom_script.sh:/vdirsyncer/custom_script.sh  # Custom Script

```

You have to mount a local folder containing the *config* file. [How to config](http://vdirsyncer.pimutils.org/en/stable/tutorial.html "Vdirsyncer configuration")

In the mounted folder you will also find a *config.example* which I copied inside the container for a quick reference.

The configuration file name is just **config**. Write everything in *.ini* style, like it is shown in the docs and in my *config.example*!

**Attention:** It is not recommended to use `AUTODISCOVER=true` by default, if you have never used *Vdirsyncer* before! If you set it to true, it will automatically accept everything `Vdirsyncer` asks, so don't ruin your calender/contacts structure! **Use it only if you know what you are doing!**

For first time use I recommend running `docker exec -it vdirsyncer vdirsyncer discover`. Maybe you have to say yes/no to a few questions, asked by *Vdirsyncer*. **[READ THE DOCS!](http://vdirsyncer.pimutils.org/en/stable/tutorial.html "Official Documentation")**

After you ran `docker exec -it vdirsyncer vdirsyncer discover` you can either run `docker exec -it vdirsyncer /bin/bash -c "vdirsyncer metasync && vdirsyncer sync"` or, if you have not set `AUTOSYNC=true`, set it to *true* and restart the container with `docker compose restart`. If you already set it to true, you can just wait until the cronjob runs or, as I said, run `docker exec -it vdirsyncer /bin/bash -c "vdirsyncer metasync && vdirsyncer sync"` to do it manually once.

Now it will sync everything for the first time.

When everything is okay, you can adjust the `CRON_TIME` value to your desired time. Check out [Crontab.guru](https://crontab.guru/ "Crontab.guru") for help. Default synctime value is 15 minutes `CRON_TIME=*/15 * * * *`.

Everything that is done by *Supercronic* will get written to the *log file* and to the docker logs! Run `docker logs -f vdirsyncer` or `docker compose logs -f` to watch the logs.

### User

`Vdirsyncer` does run with an user called `vdirsyncer` inside the container and not as root.<br>
The `UID` and `GID` for this user are `1000`, so be careful, if you use a bind mount instead of a docker volume.

### Google specifics

**Attention for Google users:** As you can read in the [Docs](http://vdirsyncer.pimutils.org/en/stable/config.html#google "Google Docs Vdirsyncer") you have to specify a path for `token_file = "PATH"`. In order to work properly, use an **absolute path!** So for the carddav storage set the `token_file` like `token_file = "/vdirsyncer/google_carddav"`and for the caldav storage like `token_file = "/vdirsyncer/google_calendar"`.<br>
The reason is, cron does not run the `vdirsyncer` command directly inside the `/vdirsyncer` folder, so if you use a relative path, `vdirsyncer` does not know where your google tokens are stored and the `AUTOSYNC` fails!

**Even more attention for Google user:** Because Google is Google you have to follow this instruction to get the Google sync working again: [Google Instruction](https://github.com/pimutils/vdirsyncer/issues/975#issuecomment-1275698939 "Google Instruction").<br>
**You can skip step 9, this has been done for you during the container build!**<br>
This has been tested and confirmed working for `Vdirsyncer 0.18.0` from my side.<br>
For `Vdirsyncer 0.19.2` you have to follow this instruction to get the Google sync working again: [Google Instruction](https://github.com/pimutils/vdirsyncer/issues/1063#issuecomment-1910758500 "Google Instruction")<br>
This has been tested and confirmed working for `Vdirsyncer 0.19.0`, `Vdirsyncer 0.19.1` and `Vdirsyncer 0.19.2` from my side.<br>

### Environment Variables

You can set nine different environment variables if you want to:

| **Variable** | **Info** | **Value** |
|:----:|:----:|:----:|
|   `TZ`   |   to set the corrent container and log time   |   default to `Europe/Vienna`, look [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones "Timezones") for possible values  |
|   `AUTODISCOVER`   |   is used to automatically run `vdirsyncer discover`   |   default to `false`, can be `true`   |
|   `AUTOSYNC`   |   is used to automatically run `vdirsyncer metasync && vdirsyncer sync`   |   default to `false`, can be `true`   |
|   `AUTOUPDATE`   |   is used to automatically update `Vdirsyncer` with all dependencies on container startup   |   default to `false`, can be `true`   |
|   `CRON_TIME`   |   for `Supercronic`, you can adjust it to whatever time you want to   |   default to `*/15 * * * *`, look [here](https://crontab.guru/ "Crontab Generator") for crontab generator   |
|   `POST_SYNC_SCRIPT_FILE`   |   Custom script file location, which can be used to automatically run a script after the cronjob `vdirsyncer` command(s)   |   optional, default to `nothing` <br> Example: /vdirsyncer/custom_script.sh <br> You have to mount the file by yourself! <br> Needs to be a bash script!   |
|   `LOG`   |   if you want to adjust the log file destination   |   optional, default to `/vdirsyncer/vdirsyncer.log`   |
|   `LOG_LEVEL`   |   if you want to adjust the log level   |   optional, default to `nothing` --> normal supercronic output <br> Can be `-quiet`, `-debug` or `no value` --> leave variable empty   |
|   `VDIRSYNCER_CONFIG`   |   location, where *Vdirsyncer* reads the config from   |   default to /vdirsyncer/config **DON'T CHANGE!**   |


**New in `2.4.1`:** The `UID` and `GID` variables now have default values, which are not changable!
* `UID` - default to `1000`.
* `GID` - default to `1000`.

---

**Attention**: As I mentioned, don't use `AUTOSYNC=true` and `AUTODISCOVER=true` as default. If you are running *Vdirsyncer* for the first time, just try everything manually, before you enable `AUTOSYNC` and `AUTODISCOVER`!

**Attention 2**: I recommend using this way for the pairs `collections = [["mytest", "test", "3b4c9995-5c67-4021-9fa0-be4633623e1c"]]` [LINK](http://vdirsyncer.pimutils.org/en/stable/tutorial.html#advanced-collection-configuration-server-to-server-sync)

**Attention 3**: Nextcloud fucks up the whole thing pretty much, if you try to sync contacts from Nextcloud to Google or Apple. I don't know why, maybe it's a bug in *vdirsyncer*, so I decided to pair Nextcloud with a [read_only](http://vdirsyncer.pimutils.org/en/stable/tutorial.html#advanced-collection-configuration-server-to-server-sync) storage. This way Nextcloud gets everything and does not fuck things up (Maybe also a problem with Owncloud, but I did not test it) 

---

## Versions
**2.5.2 - 08.02.2024:** Merged Pull Request for POST_SYNC_SCRIPT_FILE variable, to automatically run a custom script after the cronjob `vdirsyncer` command(s) and updated Alpine to 3.19.1 - Vdirsyncer 0.19.2, Alpine 3.19.1, Python 3.11.6, Pip 24.0.0, Pipx 1.4.3

**2.5.1 - 07.02.2024:** Updated Alpine to 3.18.6, Python to 3.11.6, Pip to 24.0.0 and Pipx to 1.4.3 - Vdirsyncer 0.19.2, Alpine 3.18.6, Python 3.11.6, Pip 24.0.0, Pipx 1.4.3

**2.5.0 - 08.09.2023:** Updated Vdirsyncer to 0.19.2, Alpine to 3.18.3, Python to 3.11.5 and Pip to 23.2.1 - Vdirsyncer 0.19.2, Alpine 3.18.3, Python 3.11.5, Pip 23.2.1, Pipx 1.2.0

<details>
<summary>Old Version History</summary><br>

**2.4.5 - 14.07.2023:** Supercronic start issue resolved, if LOG_LEVEL environment variable is empty and Alpine packages update - Vdirsyncer 0.19.1, Alpine 3.18.2, Python 3.11.4, Pip 23.1.2, Pipx 1.2.0

**2.4.4 - 07.07.2023:** Option to set the Supercronic log level - Vdirsyncer 0.19.1, Alpine 3.18.2, Python 3.11.4, Pip 23.1.2, Pipx 1.2.0

**2.4.3 - 23.06.2023:** Vdirsyncer global install, updated Alpine to 3.18.2 and Python to 3.11.4 - Vdirsyncer 0.19.1, Alpine 3.18.2, Python 3.11.4, Pip 23.1.2, Pipx 1.2.0

**2.4.2 - 12.05.2023:** Fixed Cronjob bug and switched to Supercronic instead of Cron, new Healthcheck to monitor the Supercronic process - Vdirsyncer 0.19.1, Alpine 3.17.3, Python 3.10.11, Pip 23.1.2, Pipx 1.2.0

**2.4.1 - 03.05.2023:** Added a Vdirsyncer autoupdate function, dropped root/sudo privileges completely, set UID and GID to a static value (1000) and dropped linux/arm/v7 Docker Image (because almost no one used it) - Vdirsyncer 0.19.1, Alpine 3.17.3, Python 3.10.11, Pip 23.1.2, Pipx 1.2.0

**2.4.0 - 03.05.2023:** Updated Vdirsyncer to 0.19.1, Dockerfile updated, fixed Google redirect_uri, bumped Alpine to 3.17.3, Python to 3.10.11, Pip to 23.1.2, Pipx to 1.2.0 - Vdirsyncer 0.19.1, Alpine 3.17.3, Python 3.10.11, Pip 23.1.2, Pipx 1.2.0

**2.3.2 - 14.11.2022:** Bumped Alpine to 3.16.3 and Python to 3.10.8 - Vdirsyncer 0.18.0, Alpine 3.16.3, Python 3.10.8, Pip 22.1.1

**2.3.1 - 22.06.2022:** Bumped Alpine to 3.16.0, Python to 3.10.4 and Pip to 22.1.1 - Vdirsyncer 0.18.0, Alpine 3.16.0, Python 3.10.4, Pip 22.1.1

**2.3.0 - 25.02.2022:** Changed default user from `root` to `Vdirsyncer` with `UID=1000` and `GID=1000`. You can also change the `UID` and `GID` as you like with the environment variables. - Vdirsyncer 0.18.0, Alpine 3.15, Python 3.9.7, Pip 20.3.4

**2.2.1 - 27.01.2022:** Fixed Crontab Bug - Vdirsyncer 0.18.0, Alpine 3.15, Python 3.9.7, Pip 20.3.4

**2.2 - 23.11.2021:** Bumped Alpine to 3.15 and Python to 3.9.7 - Vdirsyncer 0.18.0, Alpine 3.15, Python 3.9.7, Pip 20.3.4

**2.1.3 - 23.10.2021:** Added TZ environment variable, to set correct timezone - Vdirsyncer 0.18.0, Alpine 3.14.2, Python 3.9.5, Pip 20.3.4

**2.1.2 - 07.10.2021:** Added tzdata for correct container time, so logs have the correct timestamp - Vdirsyncer 0.18.0, Alpine 3.14.2, Python 3.9.5, Pip 20.3.4

**2.1.1 - 29.08.2021:** Added Log Timestamp and bumped Alpine to 3.14.2 - Vdirsyncer 0.18.0, Alpine 3.14.2, Python 3.9.5, Pip 20.3.4

**2.1 - 27.08.2021:** Added Log Persistence and Docker Image at [Github Container Registry](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/pkgs/container/vdirsyncer "Github Container Registry") available - Vdirsyncer 0.18.0, Alpine 3.14.1, Python 3.9.5, Pip 20.3.4

**2.0 - 22.08.2021:** Almost a complete Rewrite, dropped Ofelia and implemented Cron - Vdirsyncer 0.18.0, Alpine 3.14.1, Python 3.9.5, Pip 20.3.4

**1.0.1 - 20.08.2021:** Adjusted config.example - Vdirsyncer 0.18.0, Alpine 3.14.1, Python 3.9.5, Pip 20.3.4

**1.0 - 20.08.2021:** Inital Docker Hub Push - Vdirsyncer 0.18.0, Alpine 3.14.1, Python 3.9.5, Pip 20.3.4

</details>

---
### Hope you enjoy it! :)
---

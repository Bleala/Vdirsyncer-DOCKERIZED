# [Vdirsyncer](https://vdirsyncer.pimutils.org/en/stable/index.html "Official Documentation")-DOCKERIZED
[![GitHub Release](https://img.shields.io/github/v/release/Bleala/Vdirsyncer-DOCKERIZED?style=flat&label=Version)](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/releases)
[![Docker Stars](https://img.shields.io/docker/stars/bleala/vdirsyncer?style=flat&label=Docker%20Stars)](https://hub.docker.com/r/bleala/vdirsyncer)
[![Docker Pulls](https://img.shields.io/docker/pulls/bleala/vdirsyncer?style=flat&label=Docker%20Pulls)](https://hub.docker.com/r/bleala/vdirsyncer)
[![Container Build Check 🐳✅](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/actions/workflows/container-build-check.yaml/badge.svg)](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/actions/workflows/container-build-check.yaml)

Vdirsyncer - sync calendars and addressbooks between servers and the local filesystem. DOCKERIZED! 

---

## About Vdirsyncer
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

---

## Links

Official Github Repository: https://github.com/pimutils/vdirsyncer

Docs: https://vdirsyncer.pimutils.org/en/stable/tutorial.html

My Github Repository: https://github.com/Bleala/Vdirsyncer-DOCKERIZED

---

## Downloads

Docker Hub: https://hub.docker.com/r/bleala/vdirsyncer

Github Container Registry: https://github.com/-/bleala/packages/container/package/vdirsyncer

Quay.io: https://quay.io/repository/bleala/vdirsyncer

---

## Image, Versions and Architecture

I built this image based on [Alpine Linux](https://hub.docker.com/_/alpine "Alpine Linux Image") and set up everything with python3, pip3 and pipx.

There will always be two different versions:

| Tag | Content |
| ------------- |:-------------:|
| Latest    | Contains the latest stable version |
| 2.x     | Contains the Vdirsyncer, Python and Alpine versions mentioned at the bottom of the page | 

There are also several platforms supported:

Platforms:
* linux/amd64
* linux/arm64 

---

## Image Signing & Verification

To ensure the authenticity and integrity of my images, all `bleala/vdirsyncer` images pushed to `Docker Hub` and `GitHub Container Registry` (and maybe more in the future) are signed using [Cosign](https://github.com/sigstore/cosign "Cosign").

I use a static key pair for signing. The public key required for verification, `cosign.pub`, is available in the root of this GitHub repository:
* **Public Key:** [`cosign.pub`](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/blob/main/cosign.pub "cosign.pub")

### How to Verify an Image

You can verify the signature of an image to ensure it hasn't been tampered with and originates from me.

1.  **Install Cosign:**
    If you don't have Cosign installed, follow the official installation instructions: [Cosign Installation Guide](https://docs.sigstore.dev/cosign/system_config/installation/ "Cosign Installation Guide").

2.  **Obtain the Public Key:**
    Download the [`cosign.pub`](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/blob/main/cosign.pub "cosign.pub") file from this repository or clone the repository to access it locally.

3.  **Verify the Image:**
    Use the `cosign verify` command. It is highly recommended to verify against the image **digest** (e.g., `sha256:...`) rather than a mutable tag (like `latest` or `1.23.0`). You can find image digests on Docker Hub or GitHub Container Registry.

    ```bash
    # Ensure 'cosign.pub' is in your current directory, or provide the full path to it.
    # Replace <registry>/bleala/vdirsyncer@sha256:<image-digest> with the actual image reference and its digest.

    # Example for an image on Docker Hub:
    cosign verify --key cosign.pub docker.io/bleala/vdirsyncer@sha256:<ACTUAL_IMAGE_DIGEST_HERE>

    # Example for an image on GitHub Container Registry:
    cosign verify --key cosign.pub ghcr.io/bleala/vdirsyncer@sha256:<ACTUAL_IMAGE_DIGEST_HERE>
    ```

    For instance, to verify the `dev` tag with the following digest `sha256:c31bfe88a1922ca891762803011e3bd55ad86fd12192b56100ed52de1050af4b`:
    ```bash
    cosign verify --key cosign.pub docker.io/bleala/vdirsyncer@sha256:c31bfe88a1922ca891762803011e3bd55ad86fd12192b56100ed52de1050af4b
    ```

    A successful verification will output information like this:

    ```
    cosign verify --key cosign.pub docker.io/bleala/vdirsyncer@sha256:c31bfe88a1922ca891762803011e3bd55ad86fd12192b56100ed52de1050af4b

    Verification for index.docker.io/bleala/vdirsyncer@sha256:c31bfe88a1922ca891762803011e3bd55ad86fd12192b56100ed52de1050af4b --
    The following checks were performed on each of these signatures:
      - The cosign claims were validated
      - Existence of the claims in the transparency log was verified offline
      - The signatures were verified against the specified public key

    [{"critical":{"identity":{"docker-reference":"index.docker.io/bleala/vdirsyncer"},"image":{"docker-manifest-digest":"sha256:c31bfe88a1922ca891762803011e3bd55ad86fd12192b56100ed52de1050af4b"},"type":"cosign container image signature"},"optional":{"Bundle":{"SignedEntryTimestamp":"MEYCIQCbmNMsqDS+YNSKcAEk7duy99v2E/FjA5Vrxgv43wAs8wIhANjKTRUkDof9P0w0otdcNwmgHOr1q/MaC52Zk7qk+x81","Payload":{"body":"eyJhcGlWZXJzaW9uIjoiMC4wLjEiLCJraW5kIjoiaGFzaGVkcmVrb3JkIiwic3BlYyI6eyJkYXRhIjp7Imhhc2giOnsiYWxnb3JpdGhtIjoic2hhMjU2IiwidmFsdWUiOiI2ZGRmMDY0ZDE0MzJmNDcwZjYyNTE0NzIzZTM0YWNhMjljNDJmMTY2ZWI2MWRlMTA3ZjFlZDEwODQ0OTJiMzAzIn19LCJzaWduYXR1cmUiOnsiY29udGVudCI6Ik1FUUNJQi9idDZaR0dKYjVkQW9WcGxSVDdYVmZaei96eCtCbllYN25YTElNNE1kb0FpQjNENUlvWlk4YnBQMnhlcDZlSHJZN1dFdjMwcUhxSkk1VldpWFNpWHRRdXc9PSIsInB1YmxpY0tleSI6eyJjb250ZW50IjoiTFMwdExTMUNSVWRKVGlCUVZVSk1TVU1nUzBWWkxTMHRMUzBLVFVacmQwVjNXVWhMYjFwSmVtb3dRMEZSV1VsTGIxcEplbW93UkVGUlkwUlJaMEZGU0VWWFRFYzVjVVI2VFdGdlJ6TlJTSGxXTUhoVFRVZzNRblF3VGdvMVRVWkRNWEV3VFhabE5DOHZVMmwxZVZWbU5VRnBaRVJZY2s5S1kwaEdSalYxZERWUVMyNVViMUZ6YjNWNWRGVTBXVmhoWlM5bU1UQlJQVDBLTFMwdExTMUZUa1FnVUZWQ1RFbERJRXRGV1MwdExTMHRDZz09In19fX0=","integratedTime":1756728100,"logIndex":456084926,"logID":"c0d23d6ad406973f9559f3ba2d1ca01f84147d8ffc5b8445c224f98b9591801d"}}}}]
    ```

---

## Usage

To start the container you can run `docker run -d -e AUTOSYNC=true -v /path/to/local/folder:/vdirsyncer bleala/vdirsyncer:latest`, but since docker compose is easier to maintain, I'll give you a valid docker compose example.


```docker-compose.yml
networks:                                 
  vdirsyncer:
    driver: bridge

volumes:
  vdirsyncer:
    name: vdirsyncer
    driver: local

services:
  # Vdirsyncer - sync calendars and addressbooks between servers and the local filesystem. DOCKERIZED!
  # https://hub.docker.com/r/bleala/vdirsyncer
  app:
    image: bleala/vdirsyncer:latest
    container_name: vdirsyncer
    restart: unless-stopped
    networks:
      vdirsyncer:
    environment:
      TZ: # set your timezone, for correct container and log time, default to Europe/Vienna
      AUTODISCOVER: # set to true for automatic discover, default to false
      AUTOSYNC: # set to true for automatic sync, default to false
      AUTOUPDATE: # set to true for automatic Vdirsyncer and dependencies updates on container startup, default to false
      CRON_TIME: # adjust autosync /-discover time, default to 15 minutes - */15 * * * * 
      # Cron Time need to be set in Cron format - look here for generator https://crontab.guru/
      # Set CRON_TIME like that --> */15 * * * *
      # Optional
      PRE_SYNC_SCRIPT_FILE: # optional,  set to script path to automatically run your custom script before the cronjob `vdirsyncer` command(s), default to nothing
      POST_SYNC_SCRIPT_FILE: # optional,  set to script path to automatically run your custom script after the cronjob `vdirsyncer` command(s), default to nothing
      LOG: # optional, default to /vdirsyncer/vdirsyncer.log
      LOG_LEVEL: # optional, default is normal output from supercronic
    volumes:
      - vdirsyncer:/vdirsyncer              # Docker Volume
      - /path/to/config:/vdirsyncer/config  # Vdirsyncer Config
      # Optional
      - /path/to/custom_before_script.sh:/vdirsyncer/custom_before_script.sh  # Custom Before Script
      - /path/to/custom_after_script.sh:/vdirsyncer/custom_after_script.sh  # Custom After Script
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

---

## User

`Vdirsyncer` does run with an user called `vdirsyncer` inside the container and not as root.<br>
The `UID` and `GID` for this user are `1000`, so be careful, if you use a bind mount instead of a docker volume.

If you need to set a custom `UID` and `GID` add the `user` key to your `docker-compose.yml`.

Example:<br>
`user: "your_UID:your_GID"`

<details>
<summary>Complete docker-compose.yml with the `user` key</summary><br>

```docker-compose.yml
networks:                                 
  vdirsyncer:
    driver: bridge

volumes:
  vdirsyncer:
    name: vdirsyncer
    driver: local

services:
  # Vdirsyncer - sync calendars and addressbooks between servers and the local filesystem. DOCKERIZED!
  # https://hub.docker.com/r/bleala/vdirsyncer
  app:
    image: bleala/vdirsyncer:latest
    container_name: vdirsyncer
    restart: unless-stopped
    user: "your_UID:your_GID"
    networks:
      vdirsyncer:
    environment:
      TZ: # set your timezone, for correct container and log time, default to Europe/Vienna
      AUTODISCOVER: # set to true for automatic discover, default to false
      AUTOSYNC: # set to true for automatic sync, default to false
      AUTOUPDATE: # set to true for automatic Vdirsyncer and dependencies updates on container startup, default to false
      CRON_TIME: # adjust autosync /-discover time, default to 15 minutes - */15 * * * * 
      # Cron Time need to be set in Cron format - look here for generator https://crontab.guru/
      # Set CRON_TIME like that --> */15 * * * *
      # Optional
      PRE_SYNC_SCRIPT_FILE: # optional,  set to script path to automatically run your custom script before the cronjob `vdirsyncer` command(s), default to nothing
      POST_SYNC_SCRIPT_FILE: # optional,  set to script path to automatically run your custom script after the cronjob `vdirsyncer` command(s), default to nothing
      LOG: # optional, default to /vdirsyncer/vdirsyncer.log
      LOG_LEVEL: # optional, default is normal output from supercronic
    volumes:
      - vdirsyncer:/vdirsyncer              # Docker Volume
      - /path/to/config:/vdirsyncer/config  # Vdirsyncer Config
      # Optional
      - /path/to/custom_before_script.sh:/vdirsyncer/custom_before_script.sh  # Custom Before Script
      - /path/to/custom_after_script.sh:/vdirsyncer/custom_after_script.sh  # Custom After Script
```

</details>

---

## Google specifics

**Attention for Google users:** As you can read in the [Docs](http://vdirsyncer.pimutils.org/en/stable/config.html#google "Google Docs Vdirsyncer") you have to specify a path for `token_file = "PATH"`. In order to work properly, use an **absolute path!** So for the carddav storage set the `token_file` like `token_file = "/vdirsyncer/google_carddav"`and for the caldav storage like `token_file = "/vdirsyncer/google_calendar"`.<br>
The reason is, cron does not run the `vdirsyncer` command directly inside the `/vdirsyncer` folder, so if you use a relative path, `vdirsyncer` does not know where your google tokens are stored and the `AUTOSYNC` fails!

**Even more attention for Google user:** Because Google is Google you have to follow this instruction to get the Google sync working again.<br>
For `Vdirsyncer 0.19.x` you have to follow this instruction to get the Google sync working again: [Google Instruction](https://github.com/pimutils/vdirsyncer/issues/1063#issuecomment-1910758500 "Google Instruction")<br>
This has been tested and confirmed working for `Vdirsyncer 0.19.0`, `Vdirsyncer 0.19.1`, `Vdirsyncer 0.19.2` and `Vdirsyncer 0.19.3` from my side.<br>

---

## Environment Variables

You can set eleven different environment variables if you want to:

| **Variable** | **Info** | **Value** |
|:----:|:----:|:----:|
|   `TZ`   |   to set the corrent container and log time   |   default to `Europe/Vienna`, look [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones "Timezones") for possible values  |
|   `AUTODISCOVER`   |   is used to automatically run `vdirsyncer discover`   |   default to `false`, can be `true`   |
|   `AUTOSYNC`   |   is used to automatically run `vdirsyncer metasync && vdirsyncer sync`   |   default to `false`, can be `true`   |
|   `AUTOUPDATE`   |   is used to automatically update `Vdirsyncer` with all dependencies on container startup   |   default to `false`, can be `true`   |
|   `CRON_TIME`   |   for `Supercronic`, you can adjust it to whatever time you want to   |   default to `*/15 * * * *`, look [here](https://crontab.guru/ "Crontab Generator") for crontab generator   |
|   `PRE_SYNC_SCRIPT_FILE`   |   Custom script file location, which can be used to automatically run a script before the cronjob `vdirsyncer` command(s)   |   optional, default to `nothing` <br> Example: /vdirsyncer/custom_before_script.sh <br> You have to mount the file by yourself! <br> Needs to be a bash script!   |
|   `POST_SYNC_SCRIPT_FILE`   |   Custom script file location, which can be used to automatically run a script after the cronjob `vdirsyncer` command(s)   |   optional, default to `nothing` <br> Example: /vdirsyncer/custom_after_script.sh <br> You have to mount the file by yourself! <br> Needs to be a bash script!   |
|   `VDIRSYNCER_SYNC_FLAGS`   |   if you want to enable flags for the `vdirsyncer sync` command   |   optional, default to `nothing` <br> Example: --force-delete <br>   |
|   `LOG`   |   if you want to adjust the log file destination   |   optional, default to `/vdirsyncer/vdirsyncer.log`   |
|   `LOG_LEVEL`   |   if you want to adjust the log level   |   optional, default to `nothing` --> normal supercronic output <br> Can be `-passthrough-logs`, `-quiet`, `-debug` or `no value` --> leave variable empty   |
|   `VDIRSYNCER_CONFIG`   |   location, where *Vdirsyncer* reads the config from   |   default to /vdirsyncer/config **DON'T CHANGE!**   |

---

**Attention**: As I mentioned, don't use `AUTOSYNC=true` and `AUTODISCOVER=true` as default. If you are running *Vdirsyncer* for the first time, just try everything manually, before you enable `AUTOSYNC` and `AUTODISCOVER`!

**Attention 2**: I recommend using this way for the pairs `collections = [["mytest", "test", "3b4c9995-5c67-4021-9fa0-be4633623e1c"]]` [LINK](http://vdirsyncer.pimutils.org/en/stable/tutorial.html#advanced-collection-configuration-server-to-server-sync)

**Attention 3**: Nextcloud fucks up the whole thing pretty much, if you try to sync contacts from Nextcloud to Google or Apple. I don't know why, maybe it's a bug in *vdirsyncer*, so I decided to pair Nextcloud with a [read_only](http://vdirsyncer.pimutils.org/en/stable/tutorial.html#advanced-collection-configuration-server-to-server-sync) storage. This way Nextcloud gets everything and does not fuck things up (Maybe also a problem with Owncloud, but I did not test it) 

---

## Contribution

I'm glad, if you want to contribute something to the `Vdirsyncer` container.

Feel free to create a PR with your changes and I will merge it, if it's ok.

**Attention**: Please use the `main` branch for pull requests, not the `dev` branch!

---

## Versions
**2.5.8 - 01.09.2025:**<br>
* Added the `VDIRSYNCER_SYNC_FLAGS` variable, to set a flag for the `vdirsyncer sync` command. Fix for [Issue #54](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/issues/54#issuecomment-2919516303 "Issue #54").<br>
* Updated Alpine to Alpine 3.22.1, Python to 3.12.11 and Pip to 25.2.<br>

**Current Versions:**<br>
* Vdirsyncer 0.19.3, Alpine 3.22.1, Python 3.12.11, Pip 25.2, Pipx 1.7.1

<details>
<summary>Old Version History</summary><br>

**2.5.7 - 17.05.2025:**<br>
* Added the `PRE_SYNC_SCRIPT_FILE` variable, to automatically run a custom script before the cronjob `vdirsyncer` command(s). Fix for [Issue #40](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/issues/40 "Issue #40").<br>
* Changed crontab file to `666`. Fix for [Issue #20](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/issues/20 "Issue #20").<br>
* Fixed the `POST_SYNC_SCRIPT_FILE` not executed problem. Fix for [Issue #39](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/issues/39 "Issue #39").<br>
* Updated Alpine to 3.21.3, Python to 3.12.10 and Pip to 25.1.1.<br>

**2.5.6 - 09.01.2025:** Updated Alpine to 3.21.2, Python to 3.12.8 and Pip to 24.3.1. - Vdirsyncer 0.19.3, Alpine 3.21.2, Python 3.12.8, Pip 24.3.1, Pipx 1.7.1

**2.5.5 - 04.10.2024:** Updated Vdirsyncer to 0.19.3, Alpine to 3.20.3, Python to 3.12.6 and Pipx to 1.7.1. Fixed multiple cronjobs [Issue #29](https://github.com/Bleala/Vdirsyncer-DOCKERIZED/issues/29 "Issue #29")  - Vdirsyncer 0.19.3, Alpine 3.20.3, Python 3.12.6, Pip 24.2.0, Pipx 1.7.1

**2.5.4 - 18.09.2024:** Fix rm parameter  - Vdirsyncer 0.19.2, Alpine 3.20.2, Python 3.12.3, Pip 24.2.0, Pipx 1.6.0

**2.5.3 - 21.08.2024:** Dependencies update: Alpine to 3.20.2, Python to 3.12.3, Pip to 24.2.0, Pipx to 1.6.0  - Vdirsyncer 0.19.2, Alpine 3.20.2, Python 3.12.3, Pip 24.2.0, Pipx 1.6.0

**2.5.2 - 08.02.2024:** Merged Pull Request for POST_SYNC_SCRIPT_FILE variable, to automatically run a custom script after the cronjob `vdirsyncer` command(s) and updated Alpine to 3.19.1 - Vdirsyncer 0.19.2, Alpine 3.19.1, Python 3.11.6, Pip 24.0.0, Pipx 1.4.3

**2.5.1 - 07.02.2024:** Updated Alpine to 3.18.6, Python to 3.11.6, Pip to 24.0.0 and Pipx to 1.4.3 - Vdirsyncer 0.19.2, Alpine 3.18.6, Python 3.11.6, Pip 24.0.0, Pipx 1.4.3

**2.5.0 - 08.09.2023:** Updated Vdirsyncer to 0.19.2, Alpine to 3.18.3, Python to 3.11.5 and Pip to 23.2.1 - Vdirsyncer 0.19.2, Alpine 3.18.3, Python 3.11.5, Pip 23.2.1, Pipx 1.2.0

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

# Talend Remote Engine in Docker

:warning: **This repository has just been quickly hacked together as a proof of concept and is not officially supported by [Talend, Inc.](https://github.com/Talend)**

This repository contains a basic `Dockerfile` to show how a remote engine can be run in Docker. In order to build this image, you have to log in to the [Talend Portal](https://portal.eu.cloud.talend.com/) and download the *Archive for Linux (tar.gz)* in the desired version into the `remote-engine/` subfolder.

```bash
# When setting the version, make sure the exact string is contained in the Talend Remote Engine archive's name
# Usually the archive name resembles to "Talend-RemoteEngine-V<X>.<Y>.<Z>-<BUILD_NUMBER>.tar.gz"
export TALEND_RE_VERSION="2.14.0"
cd ..
docker build -t hpmanoj/talend-remote-engine:${TALEND_RE_VERSION} --build-arg TALEND_RE_VERSION=${TALEND_RE_VERSION} .
```

Start a container from your newly built image. Simply place your environment variables in a dedicated file (see `example.env` in this repository). Don't forget to persist the Engine's configuration to be able to connect on a container restart.

```bash
docker run -d --env-file .env --volume "remote-engine-data:/opt/talend/remote-engine/etc" manojhprao/talend-remote-engine:${TALEND_RE_VERSION}
```

Alternatively export the values to your environment and pass them along.

```bash
export TALEND_RE_KEY="<Your super secret pairing key>"
export TALEND_RE_NAME="<Name of your Remote Engine>"
export TALEND_RE_DESC="<Some descriptive words>"
# One of eu, us, ap, us-west
export TALEND_RE_REGION=eu
docker run -d --env TALEND_RE_KEY --env TALEND_RE_NAME --env TALEND_RE_DESC --env TALEND_RE_REGION --volume "remote-engine-data:/opt/talend/remote-engine/etc" manojhprao/talend-remote-engine:${TALEND_RE_VERSION}
```
```

-------
### Using a Local Directory for Configuration Persistence

If you prefer to bind-mount a local directory (e.g., `$PWD/remote-engine/etc`) instead of using a Docker named volume, you **must** extract the default configuration files from the image first. Mounting an empty directory will hide the original files inside the container and cause it to fail on startup.

**1. Extract the default configuration:**
```bash
# Create a temporary container and copy its configuration directory to your host
docker create --name temp-re hpmanoj/talend-remote-engine:2.14.0
docker cp temp-re:/opt/talend/remote-engine/etc ./remote-engine/
docker rm temp-re
```

**2. Start the container with the populated local folder mounted:**
```bash
docker run -d --env-file example.env --volume "$PWD/remote-engine/etc:/opt/talend/remote-engine/etc" hpmanoj/talend-remote-engine:2.14.0
```
-------

```bash
# 1. Stop the container if it's running
docker stop <container_name_or_id>

# 2. Remove the container (keep the volume)
docker rm <container_name_or_id>

# 3. Run it again with the same command
docker run -d --env-file .env --volume "remote-engine-data:/opt/talend/remote-engine/etc" manojhprao/talend-remote-engine:2.14.0
```

-------
Attach into the shell
docker exec -it 88a6a1b12c5aed30a633358a45159022c94d4f093acd5050fa6347d84818ecd9 bash

-------


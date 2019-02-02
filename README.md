# [Motion](https://github.com/Motion-Project/motion) + [MotionEye web frontend](https://github.com/ccrisan/motioneye) inside a docker container

[![badge](https://images.microbadger.com/badges/image/hurlenko/motioneye.svg)](https://hub.docker.com/r/hurlenko/motioneye/ "Go to DockerHub")

- [How to run](#how-to-run)
  - [Simple Usage](#simple-usage)
  - [Full Usage](#full-usage)
  - [Supported Environment Variables](#supported-environment-variables)
  - [Supported Volumes](#supported-volumes)
- [Docker Hub](#docker-hub)

## MotionEye

![MotionEye](https://raw.githubusercontent.com/wiki/ccrisan/motioneyeos/images/settings-panel.png)

## How to run

### Supported Architectures

This project utilises the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list).

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| amd64 | amd64 |
| arm64 | arm64 |

### Simple Usage

```bash
docker run -d --name motioneye -p 80:8765 hurlenko/motioneye
```

### Full Usage

```bash
docker run -d \
    --name motioneye \
    -p 80:8765 \                             # webui
    -v /DOWNLOAD_DIR:/var/lib/motioneye \    # replace /DOWNLOAD_DIR with your download directory in your host.
    -v /CONFIG_DIR:/etc/motioneye \          # replace /CONFIG_DIR with your configure directory in your host.
    hurlenko/motioneye
```

### Supported Volumes

- `/etc/motioneye` R/W needed for motioneye to update configurations
- `/var/run/motion` PIDs
- `/var/lib/motioneye` Video & images

### How to build

```bash
git clone https://github.com/hurlenko/motioneye-docker
cd motioneye-docker
docker build --build-arg MOTION_VERSION=4.1.1 --build-arg MOTIONEYE_VERSION=0.39.3 -t hurlenko\motioneye:arm64 -f Dockerfile .
```

## Docker Hub

  <https://hub.docker.com/r/hurlenko/motioneye/>

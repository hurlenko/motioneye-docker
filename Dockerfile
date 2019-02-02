FROM ubuntu:18.04 as builder

LABEL maintainer="hurlenko"

# https://github.com/Motion-Project/motion/releases
ARG MOTION_VERSION=4.1.1

RUN apt-get update -qqy \
    && apt-get install -qqy git wget lsb-release sudo \
    && wget https://raw.githubusercontent.com/Motion-Project/motion-packaging/master/builddeb.sh \
    && chmod +x ./builddeb.sh \
    && ./builddeb.sh hurlenko noname@unknown.com tags/release-$MOTION_VERSION Y

FROM ubuntu:18.04

# https://github.com/ccrisan/motioneye/releases
ARG MOTIONEYE_VERSION=0.39.3

COPY --from=builder *.deb /tmp/motion.deb

RUN apt-get --quiet update \
    && apt-get --quiet upgrade --yes \
    && DEBIAN_FRONTEND="noninteractive" apt-get --quiet --yes --option Dpkg::Options::="--force-confnew" --no-install-recommends install \
    curl \
    ffmpeg \
    libmysqlclient20 \
    libpq5 \
    lsb-release \
    mosquitto-clients \
    python-jinja2 \
    python-pil \
    python-pip \
    python-pycurl \
    python-setuptools \
    python-tornado \
    python-tz \
    python-wheel \
    tzdata \
    v4l-utils \
    git \
    zlib1g-dev \
    && dpkg -i /tmp/motion.deb \
    && rm /tmp/motion.deb \
    && git clone https://github.com/ccrisan/motioneye.git /tmp/motioneye \
    && cd /tmp/motioneye \
    && git checkout tags/${MOTIONEYE_VERSION} \
    && pip install /tmp/motioneye \
    && cd \
    && rm -rf /tmp/motioneye \
    && apt-get purge --yes \
    python-pip \
    python-setuptools \
    python-wheel \
    && apt-get --quiet autoremove --yes \
    && apt-get --quiet --yes clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/*.bin

# R/W needed for motioneye to update configurations
VOLUME /etc/motioneye

# PIDs
VOLUME /var/run/motion

# Video & images
VOLUME /var/lib/motioneye

EXPOSE 8765

ADD motioneye.conf /usr/share/motioneye/extra/

CMD test -e /etc/motioneye/motioneye.conf || \
    cp /usr/share/motioneye/extra/motioneye.conf /etc/motioneye/motioneye.conf ; \
    /usr/local/bin/meyectl startserver -c /etc/motioneye/motioneye.conf
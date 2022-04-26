FROM ubuntu:jammy
MAINTAINER mumumu <mumumu@mumumu.org>

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp

RUN grep '^deb ' /etc/apt/sources.list | \
  sed 's/^deb /deb-src /g' | \
  tee /etc/apt/sources.list.d/deb-src.list \
  && apt update \
  && apt install -y devscripts \
  && apt install -y build-essential \
  && apt build-dep -y sylpheed \
  && apt source sylpheed

ADD sylpheed_vi_keybind.patch /tmp/sylpheed-3.7.0

RUN cd /tmp/sylpheed-3.7.0 && patch -p0 < sylpheed_vi_keybind.patch && debuild -b -uc -us

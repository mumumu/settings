FROM ubuntu:noble
MAINTAINER mumumu <mumumu@mumumu.org>

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp

RUN cat /etc/apt/sources.list.d/ubuntu.sources | \
  sed 's/^Types: deb/Types: deb deb-src/g' | \
  tee /etc/apt/sources.list.d/sylpheed.sources \
  && cat /etc/apt/sources.list.d/sylpheed.sources \
  && apt update \
  && apt install -y devscripts \
  && apt install -y build-essential \
  && apt build-dep -y sylpheed \
  && apt source sylpheed

ADD sylpheed_vi_keybind.patch /tmp/sylpheed-3.8.0~beta1

RUN cd /tmp/sylpheed-3.8.0~beta1 && patch -p0 < sylpheed_vi_keybind.patch && debuild -b -uc -us

FROM ubuntu:20.04

ARG APT_MIRROR_HOST=mirrors.tuna.tsinghua.edu.cn
ENV DEBIAN_FRONTEND noninteractive

# modify apt source list
RUN sed -i "s/archive.ubuntu.com/${APT_MIRROR_HOST}/g" /etc/apt/sources.list \
    && sed -i "s/security.ubuntu.com/${APT_MIRROR_HOST}/g" /etc/apt/sources.list

# update source
RUN apt update

# install base tools
RUN apt install -y wget fonts-wqy-microhei

# download and install latest chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb;exit 0
RUN apt install -f -y

# config timezone
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN google-chrome-stable --version

ADD start.sh import_cert.sh /usr/bin/

RUN mkdir /data
VOLUME /data
ENV HOME=/data DEBUG_ADDRESS=0.0.0.0 DEBUG_PORT=9222

CMD ["/usr/bin/start.sh"]

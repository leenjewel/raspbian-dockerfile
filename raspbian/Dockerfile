# Version: 0.0.1
FROM resin/rpi-raspbian
MAINTAINER leenjewel "leenjewel@gmail.com"
RUN echo 'deb http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ jessie main non-free contrib' \
    > /etc/apt/sources.list
RUN echo 'deb-src http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ jessie main non-free contrib' \
    >> /etc/apt/sources.list
RUN rm -f /etc/apt/sources.list.d/*.list
RUN apt-get update


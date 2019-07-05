FROM node:slim

RUN apt-get update
RUN apt-get install -y python xdg-utils wget xz-utils
RUN wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin

RUN mkdir /build && chown node:node /build && chmod 0750 /build

USER node

WORKDIR /build


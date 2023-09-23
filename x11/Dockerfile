FROM debian:stable-slim

RUN apt-get update -y\
 && apt-get install x11-apps -y

ENV DISPLAY host.docker.internal:0.0

RUN useradd -ms /bin/bash xuser
USER xuser
WORKDIR /home/xuser/

CMD ["xeyes"]
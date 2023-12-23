FROM kei0709/ubuntu22.04_nodejs:v2.0
USER root
RUN apt-get update && apt-get install -y \
    sudo \
    software-properties-common \
    build-essential 
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt update && apt install python3.8 -y
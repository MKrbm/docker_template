FROM ubuntu:20.04 as base

FROM base as htop_base
RUN apt-get update -y && apt-get -y install curl

FROM base as wget_base
RUN apt-get update -y && apt-get -y install wget curl


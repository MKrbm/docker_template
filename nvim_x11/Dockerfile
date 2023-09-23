FROM ubuntu:22.04

RUN apt update && \
    apt-get update && \
    apt install -y curl git ripgrep tar unzip vim wget zoxide ripgrep sqlite yarn lldb  unzip 


RUN wget https://github.com/neovim/neovim/releases/download/v0.9.1/nvim-linux64.tar.gz && \
    tar -zxvf nvim-linux64.tar.gz && \
    mv nvim-linux64/bin/nvim usr/bin/nvim && \
    mv nvim-linux64/lib/nvim usr/lib/nvim && \
    mv nvim-linux64/share/nvim/ usr/share/nvim && \
    rm -rf nvim-linux64 && \
    rm nvim-linux64.tar.gz

RUN apt-get update -y\
 && apt-get install x11-apps -y

ENV DISPLAY host.docker.internal:0.0 

    
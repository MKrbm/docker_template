FROM ubuntu:20.04

RUN apt-get update

# nvmのインストールに必要なモノをインストール
RUN apt-get install -y curl git

# shellをbashに変更
SHELL [ "/bin/bash", "-c" ]

# nvmをインストール
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# lts版のnodeをインストール
RUN . $HOME/.nvm/nvm.sh && \
    nvm install --lts && \
    nvm use --lts && \
    node -v && npm -v && \
    npm i -g yarn
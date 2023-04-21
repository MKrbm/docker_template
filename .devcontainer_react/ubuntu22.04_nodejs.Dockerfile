# https://github.com/microsoft/vscode-dev-containers/tree/v0.209.6/containers/cpp/.devcontainer/base.Dockerfile

FROM ubuntu:22.04 as base
RUN echo "I'm $TARGETARCH"
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN echo "root:root" | chpasswd
RUN echo "$USERNAME:$USERNAME" | chpasswd
RUN adduser $USERNAME sudo


# change time-zone
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# change terminal colors
COPY terminal-colors-branch.sh /tmp/
RUN cat /tmp/terminal-colors-branch.sh >> ~/.bashrc

# install libs
RUN apt-get update -y && apt-get -y install git vim htop curl libatomic1

# n* git setup
RUN git config --global core.autocrlf input

USER $USERNAME

# change terminal colors
RUN cat /tmp/terminal-colors-branch.sh >> ~/.bashrc

#n* install nodejs
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

SHELL [ "/bin/bash", "-c" ]
ENV NODE_VERSION 18.12.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
# lts版のnodeをインストール
RUN . $HOME/.nvm/nvm.sh && \
    nvm install --lts && \
    nvm use --lts && \
    node -v && npm -v

# setting for ctrl + r command (easier to search history)
USER root
RUN apt-get install -y hstr 
USER ${USERNAME}
RUN hstr --show-configuration >> ~/.bashrc
COPY ssh-find-agent/ /home/${USERNAME}/ssh-find-agent/
# RUN cat ssh-find-agent.sh >> $HOME/.bashrc
COPY ssh-bashrc.sh ssh-bashrc.sh
RUN cat ssh-bashrc.sh >> ~/.bashrc
RUN echo "source /usr/share/bash-completion/completions/git \n" >> ~/.bashrc
    

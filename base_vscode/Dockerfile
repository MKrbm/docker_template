ARG VARIANT="ubuntu-22.04"

FROM mcr.microsoft.com/vscode/devcontainers/cpp:0-${VARIANT} AS base_vscode

ARG USERNAME=user
ARG GROUPNAME=user

RUN usermod -l user vscode
RUN groupmod -n user vscode
RUN echo "root:root" | chpasswd
RUN echo "$USERNAME:$USERNAME" | chpasswd
RUN usermod -d /home/$USERNAME -m $USERNAME
RUN usermod -aG sudo user 
WORKDIR /home/${USERNAME}/project
RUN git config --global --add safe.directory /home/${USERNAME}/project

# # # install some utilities
RUN apt-get update -y && apt-get -y install software-properties-common htop cmake openssh-server
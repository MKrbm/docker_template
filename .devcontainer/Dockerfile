# https://github.com/microsoft/vscode-dev-containers/tree/v0.209.6/containers/cpp/.devcontainer/base.Dockerfile

ARG VARIANT="ubuntu-22.04"
FROM mcr.microsoft.com/vscode/devcontainers/cpp:0-${VARIANT}
ARG USERNAME=user
ARG GROUPNAME=user
# ARG UID=1001
# ARG GID=1001

RUN usermod -l user vscode
RUN groupmod -n user vscode
RUN echo "root:root" | chpasswd
RUN echo "$USERNAME:$USERNAME" | chpasswd
RUN usermod -d /home/$USERNAME -m $USERNAME
RUN usermod -aG sudo user 
USER $USERNAME
WORKDIR /home/${USERNAME}/project

# # install some utilities
# RUN apt-get update && apt-get -y install htop cmake
# RUN apt-get -y install openssh-server
# RUN apt-get install cmake-curses-gui

# #install fortran
# RUN apt-get -y install gfortran

# ENV PATH="/home/user/miniconda3/bin:$PATH"
# ARG PATH="/home/user/miniconda3/bin:$PATH"
# RUN apt-get update && \
#     apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# WORKDIR /home/user
# USER root

# RUN wget -P /home/user \
#     https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#     && mkdir /home/user/.conda \
#     && bash Miniconda3-latest-Linux-x86_64.sh -b\
#     && rm -f Miniconda3-latest-Linux-x86_64.sh 
# ENV PATH=$CONDA_DIR/bin:$PATH
# ENV PATH=$CONDA_DIR/envs:$PATH
# RUN conda init

# ADD environment.yml environment.yml
# RUN conda env create -f environment.yml
# RUN rm -rf environment.yml


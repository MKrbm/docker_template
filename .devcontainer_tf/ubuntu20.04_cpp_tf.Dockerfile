
FROM tensorflow/tensorflow:2.11.0-gpu as base

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN echo "root:root" | chpasswd
RUN echo "$USERNAME:$USERNAME" | chpasswd
# change time-zone
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# change terminal colors
COPY terminal-colors-branch.sh /tmp/
RUN cat /tmp/terminal-colors-branch.sh >> ~/.bashrc

RUN apt-get update -y && apt-get -y install git vim software-properties-common htop cmake openssh-server sudo libeigen3-dev 

RUN adduser $USERNAME sudo

# # n* install python 3.9
# ARG PY_VERSION="3.9"
# RUN add-apt-repository ppa:deadsnakes/ppa
# RUN apt-get -y install python${PY_VERSION}-distutils python${PY_VERSION}-dev python${PY_VERSION} 
# RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PY_VERSION} 1 && update-alternatives --install /usr/bin/python python /usr/bin/python${PY_VERSION} 1 && \
#     apt-get -y install python3-pip

# n* install c++
RUN apt-get update -y && apt-get -y install \
    htop build-essential cmake clang libssl-dev vim openssh-server cmake-curses-gui git curl gdb libopenmpi-dev liblapack-dev libblas-dev

# n* install boost for c++
RUN apt-get -y install libboost-dev

# # n* git setup
# RUN git config --global --add safe.directory /home/${USERNAME}/project
RUN git config --global core.autocrlf input

#install libboost, openmpi, ninja
RUN apt-get install -y libopenmpi-dev liblapack-dev libblas-dev libboost-dev libboost-mpi-dev libboost-serialization-dev libboost-filesystem-dev libboost-system-dev ninja-build

# setting the locale to UTF-8
RUN apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt -y install wget \ 
    && wget https://sf.net/projects/materiappslive/files/Debian/sources/setup.sh \
    && sh setup.sh

RUN apt-get update && apt-get install -y libeigen3-dev libhdf5-dev=1.10.4+repack-11ubuntu1
COPY install-libconfig.sh install-libconfig.sh
COPY install-alpscore.sh install-alpscore.sh
RUN ./install-libconfig.sh
RUN ./install-alpscore.sh

# setting for ctrl + r command (easier to search history)
RUN add-apt-repository ppa:ultradvorka/ppa -y && apt-get update && apt-get install hstr -y && hstr --show-configuration >> ~/.bashrc && . ~/.bashrc

USER ${USERNAME}
RUN hstr --show-configuration >> ~/.bashrc

#n* change terminal colors
RUN cat /tmp/terminal-colors-branch.sh >> ~/.bashrc

WORKDIR /home/${USERNAME}
ARG CONDA_VER=latest

# x86
FROM base as base-amd64
ARG OS_TYPE=x86_64

# aarch64
FROM base as base-arm64
ARG OS_TYPE=aarch64

FROM base-${TARGETARCH} as target
# FROM base-${ARCH} as target


# install conda
ARG CONDA=Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh
RUN wget -P /home/${USERNAME} \
    http://repo.continuum.io/miniconda/${CONDA} \
    && mkdir /home/${USERNAME}/.conda \
    && bash ${CONDA} -b\
    # && ./home/${USERNAME}/anaconda3/bin/conda init
    && rm -f ${CONDA}
ENV PATH=/home/${USERNAME}/miniconda3/bin:$PATH
ENV PATH=/home/${USERNAME}/miniconda3/condabin:$PATH
RUN conda init 
RUN conda update -y conda

WORKDIR /home/${USERNAME}/project

COPY python-package.sh python-package.sh
COPY ssh-find-agent/ /home/${USERNAME}/ssh-find-agent/
COPY ssh-bashrc.sh ssh-bashrc.sh
RUN cat ssh-bashrc.sh >> ~/.bashrc
RUN echo "source /usr/share/bash-completion/completions/git \n" >> ~/.bashrc
SHELL ["/bin/bash", "-c"]
RUN ./python-package.sh







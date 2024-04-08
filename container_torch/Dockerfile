FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04 as base

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG CONDA_VER=latest
ARG HOME=/home/${USERNAME}

RUN apt-get update -y && apt-get install -y sudo
# add new user
RUN groupadd --gid $USER_GID $USERNAME \
		&& useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME && \
		echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
		chmod 0440 /etc/sudoers && \
		chmod g+w /etc/passwd 

RUN echo "root:root" | chpasswd
RUN echo "$USERNAME:$USERNAME" | chpasswd

# change terminal colors
COPY terminal-colors-branch.sh /tmp/
RUN cat /tmp/terminal-colors-branch.sh >> ~/.bashrc

# change time-zone
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y && apt-get -y install git vim htop locales wget curl 
RUN apt-get update && apt-get install -y software-properties-common openssh-server x11-apps openssh-server

# setting for git
RUN git config --global core.autocrlf input

# setting the locale to UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# setting for ctrl + r command (easier to search history)
RUN add-apt-repository ppa:ultradvorka/ppa -y && apt-get update && apt-get install hstr -y && hstr --show-configuration >> ~/.bashrc


RUN mkdir /var/run/sshd \
    && sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config \
    && sed -i 's/^#X11Forwarding yes/X11Forwarding yes/g' /etc/ssh/sshd_config \
    && sed -i 's/^#X11DisplayOffset 10/X11DisplayOffset 10/g' /etc/ssh/sshd_config \
    && sed -i 's/^#X11UseLocalhost yes/X11UseLocalhost no/g' /etc/ssh/sshd_config \
    && sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

USER ${USERNAME}
WORKDIR ${HOME}

# setup ctrl + r command 
RUN hstr --show-configuration >> ~/.bashrc

USER root

# x86
FROM base as base-amd64
ARG OS_TYPE=x86_64

# aarch64 right now arm64 is not maintained
FROM base as base-arm64
ARG OS_TYPE=aarch64

FROM base-${TARGETARCH} as target

USER ${USERNAME}
WORKDIR /home/${USERNAME}
# install conda
ARG CONDA=Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh
RUN wget -P ${HOME} \
    http://repo.continuum.io/miniconda/${CONDA} \
    && mkdir ${HOME}/.conda \
    && bash ${CONDA} -b\
    && rm -f ${CONDA}
ENV PATH=${HOME}/miniconda3/bin:${HOME}/miniconda3/condabin:$PATH
RUN conda init  \
	&& conda update -y conda

WORKDIR ${HOME}/project

# Install 
COPY ssh-find-agent/ ${HOME}/ssh-find-agent/
COPY ssh-bashrc.sh ssh-bashrc.sh

# setup bash completion
RUN cat ssh-bashrc.sh >> ~/.bashrc
RUN echo "source /usr/share/bash-completion/completions/git \n" >> ~/.bashrc
SHELL ["/bin/bash", "-c"]

# install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
# # Set up environment variables for nvm
ENV NVM_DIR /home/${USERNAME}/.nvm
ENV NODE_VERSION 18

# Insta/rootll Node.js
RUN . "${NVM_DIR}/nvm.sh" \
	&& nvm install $NODE_VERSION \
	&& nvm alias default $NODE_VERSION \
	&& nvm use default

# Set up user configuration for nvim
RUN mkdir -p /home/${USERNAME}/.config \
	&& cd /home/${USERNAME}/.config \
# If your Docker environment does not support SSH, use HTTPS instead for cloning:
	&& git clone https://github.com/MKrbm/MyNvim.git nvim

# Optionally use the nightly version instead by uncommenting the following lines
	RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
		&& chmod u+x nvim.appimage \
		&& ./nvim.appimage --appimage-extract

USER root

RUN apt-get update -y\
	&& apt-get install ripgrep unzip xclip -y

# Expose nvim globally within the container
RUN mv squashfs-root / \
	&& ln -s /squashfs-root/AppRun /usr/bin/nvim

# USER ${USERNAME}	
# RUN ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

USER root

# Expose the SSH port
RUN ssh-keygen -A
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
# ENTRYPOINT ["/entrypoint.sh"]
# ENV DISPLAY host.docker.internal:0.0 

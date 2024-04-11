FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04 as base

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install necessary packages
RUN apt-get update -y && apt-get -y install git vim software-properties-common htop cmake openssh-server sudo libeigen3-dev locales wget curl x11-apps ripgrep unzip xclip libssl-dev vim cmake-curses-gui git gdb libopenmpi-dev liblapack-dev libblas-dev libhdf5-dev libboost-dev libboost-mpi-dev libboost-serialization-dev libboost-filesystem-dev libboost-system-dev ninja-build hstr

# Setup user, timezone, locale, and other configurations
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers \
    && echo "root:root" | chpasswd \
    && echo "$USERNAME:$USERNAME" | chpasswd \
    && ln -snf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && echo Asia/Tokyo > /etc/timezone \
    && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ=Asia/Tokyo
ENV NVM_DIR /home/${USERNAME}/.nvm
ENV NODE_VERSION 18
ENV PATH=/home/${USERNAME}/miniconda3/bin:$PATH
ENV PATH=/home/${USERNAME}/miniconda3/condabin:$PATH
ENV DISPLAY host.docker.internal:0.0

# Copy necessary scripts
COPY terminal-colors-branch.sh /tmp/
COPY install-libconfig.sh install-libconfig.sh
COPY install-alpscore.sh install-alpscore.sh
COPY ssh-find-agent/ /home/${USERNAME}/ssh-find-agent/
COPY ssh-bashrc.sh ssh-bashrc.sh

# Make scripts executable and run installation scripts
RUN chmod +x ./install-libconfig.sh ./install-alpscore.sh \
    && ./install-libconfig.sh \
    && ./install-alpscore.sh \
    && rm ./install-libconfig.sh ./install-alpscore.sh

# Configure SSH and other services
RUN mkdir -p /var/run/sshd \
    && sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#X11Forwarding no/X11Forwarding yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config \
    && ssh-keygen -A  # Generate SSH host keys here


# Install Miniconda

USER ${USERNAME}

RUN wget -P /home/${USERNAME} http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /home/${USERNAME}/.conda \
    && bash /home/${USERNAME}/Miniconda3-latest-Linux-x86_64.sh -b -p /home/${USERNAME}/miniconda3 -u \
    && rm /home/${USERNAME}/Miniconda3-latest-Linux-x86_64.sh \
    && conda init \
    && conda update -y conda


# Download and run the NVM installation script
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Add NVM to the user's bash profile
RUN echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc


# Set the working directory to the user's home directory
WORKDIR /home/${USERNAME}

# Set environment variables for runtime
# Here, you can set any environment variables your application needs
# For example, PATH adjustments or environment-specific variables
ENV PATH="/home/${USERNAME}/miniconda3/bin:${PATH}"

# Switch back to the created user for security
# USER ${USERNAME}

RUN ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

# Reset user to root
USER root

# This is required to run sshd
EXPOSE 22 

COPY entrypoint.sh /entrypoint.sh

# Ensure the entrypoint script is executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint to initialize the environment
ENTRYPOINT ["/entrypoint.sh", "/bin/sh", "-c"]
CMD ["bash"]

# Be sure to use root user at the end of the dockerfile. 
FROM kei0709/ubuntu22.04-texlive:amd64

USER root

RUN apt-get update -y && apt-get -y install curl unzip x11-apps xclip ripgrep okular

USER user

## install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
# # Set up environment variables for nvm
ENV NVM_DIR /home/user/.nvm
ENV NODE_VERSION 18

## Insta/rootll Node.js
RUN . "${NVM_DIR}/nvm.sh" \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

## Set up Neovim configuration
RUN mkdir -p ~/.config \
    && git clone https://github.com/MKrbm/MyNvim.git ~/.config/nvim

USER root

## Download and install Neovim AppImage
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
            && chmod u+x nvim.appimage \
            && ./nvim.appimage --appimage-extract \
            && mv squashfs-root / \
            && ln -s /squashfs-root/AppRun /usr/bin/nvim

RUN echo "export PATH=/usr/local/texlive/2022/bin/x86_64-linux:${PATH}" >> /etc/profile
# Start with the base Arch Linux image
FROM archlinux:base

# Update the system and install base-devel and other necessary tools
RUN pacman -Syu --noconfirm \
  && pacman -S --noconfirm base-devel git sudo

# Create a new user to build the AUR package, as building as root is not allowed
RUN useradd -m user \
  && echo 'user ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/user \
  && chmod 0440 /etc/sudoers.d/user

# Switch to the new user
USER user

# Clone the paru repository
RUN git clone https://aur.archlinux.org/paru.git /home/user/paru

# Navigate to the paru directory and build the package
WORKDIR /home/user/paru
RUN makepkg -si --noconfirm

RUN paru -S --noconfirm git lazygit zoxide ripgrep sqlite fd yarn ttf-jetbrains-mono-nerd lldb nvm make unzip neovim python-pynvim 

RUN source /usr/share/nvm/init-nvm.sh && nvm install 18
RUN source /usr/share/nvm/init-nvm.sh && nvm use 18


RUN sudo pacman -Rns --noconfirm rust
RUN paru -S --noconfirm rustup
RUN rustup toolchain install nightly # or stable


RUN if command -v curl >/dev/null 2>&1; then \
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/ayamir/nvimdots/HEAD/scripts/install.sh)"; \
    else \
        bash -c "$(wget -O- https://raw.githubusercontent.com/ayamir/nvimdots/HEAD/scripts/install.sh)"; \
    fi


RUN echo 'source /usr/share/nvm/init-nvm.sh' >> /home/user/.bashrc


USER root


RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm xorg-apps xorg-xeyes
    
RUN pacman -S --noconfirm xclip

ENV DISPLAY host.docker.internal:0.0 

RUN echo 'user:user' | chpasswd # Set password for user
RUN echo 'root:root' | chpasswd
USER user
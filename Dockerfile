FROM ubuntu:22.04

WORKDIR /home

# Install Homebrew
RUN apt update && \
    apt install -y curl git build-essential gcc g++ && \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo >> /root/.bashrc && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.bashrc && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

RUN brew install neovim wget unzip fontconfig && \
    git clone https://github.com/LazyVim/starter ~/.config/nvim

# NOTE: You may need to install Nerd Fonts manually on host
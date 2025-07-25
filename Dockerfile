FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

WORKDIR /home

# Use Tsinghua University mirror for faster package downloads if necessary
# RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
#     echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
#     echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
#     echo "deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list

# Install dependencie
RUN apt update && \
    apt install -y curl wget git build-essential gcc g++ procps file sudo vim unzip && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Install oh-my-push
ENV PATH="/root/.local/bin:${PATH}"
RUN curl -s https://ohmyposh.dev/install.sh | bash -s && \
    echo >> /root/.bashrc && \
    echo 'eval "$(oh-my-posh init bash --config /root/.cache/oh-my-posh/themes/atomic.omp.json)"' >> /root/.bashrc && \
    rm -rf oh-my-posh

# Install neovim, lazy-vim
ENV PATH="${PATH}:/opt/nvim-linux-x86_64/bin"
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
    rm -rf /opt/nvim && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    rm nvim-linux-x86_64.tar.gz && \
    git clone https://github.com/LazyVim/starter /root/.config/nvim

# Install plugins for neovim
COPY plugins/ /root/.config/nvim/lua/plugins/
RUN nvim --headless +Lazy! sync +qa && \
    nvim --headless +Lazy! update +qa

# Set the default command to bash
CMD ["/bin/bash"]

# NOTE: You may need to install Nerd Fonts manually on host
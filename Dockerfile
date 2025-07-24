FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies as root
RUN apt update && \
    apt install -y curl git build-essential gcc g++ procps file sudo && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Create a non-root user 'radon' and grant sudo privileges
RUN useradd --create-home --shell /bin/bash radon && \
    echo "radon ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/radon

# Switch to the non-root user
USER radon
WORKDIR /home/radon

# Install Homebrew, tools, and configs as the non-root user in a single layer
# This ensures 'brew' is in the PATH for all subsequent commands in this layer.
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/radon/.bashrc && \
    # Install oh-my-push
    brew install jandedobbeleer/oh-my-posh/oh-my-posh && \
    mkdir -p /home/radon/.config/oh-my-posh-themes && \
    git clone https://github.com/jandedobbeleer/oh-my-posh && \
    mv oh-my-posh/themes/* /home/radon/.config/oh-my-posh-themes && \
    echo "eval \"$(oh-my-posh init bash --config ~/.config/oh-my-posh-themes/atuomatic.omp.json)\"" >> /home/radon/.bashrc && \
    rm -rf oh-my-posh && \
    # Install neovim, plugins, and tools
    brew install neovim vim wget unzip && \
    git clone https://github.com/LazyVim/starter /home/radon/.config/nvim

# Set the default command to bash
CMD ["/bin/bash"]

# NOTE: You may need to install Nerd Fonts manually on host
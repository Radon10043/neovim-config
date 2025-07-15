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
    # Install starship
    curl -sS https://starship.rs/install.sh | sh -s -- -y && \
    echo 'eval "$(starship init bash)"' >> /home/radon/.bashrc && \
    mkdir -p /home/radon/.config && \
    starship preset catppuccin-powerline -o /home/radon/.config/starship.toml && \
    # Install neovim, plugins, and tools
    brew install neovim wget unzip && \
    git clone https://github.com/LazyVim/starter /home/radon/.config/nvim

# Set the default command to bash
CMD ["/bin/bash"]

# NOTE: You may need to install Nerd Fonts manually on host
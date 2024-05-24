#!/bin/bash
sudo apt-get update -y

# Install Zsh
sudo apt-get install -y zsh libreadline-dev # for lua installation

# Install Neovim
sh -c "$(curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz | tar xz)"

# Install Node.js
curl -sL install-node.now.sh/lts | sudo $SHELL

# .dotfiles configuration
git clone https://github.com/HikiJun97/.dotfiles.git

# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Zsh Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install Lua
curl -L -R -O https://www.lua.org/ftp/lua-5.3.6.tar.gz
tar zxf lua-5.3.6.tar.gz
cd lua-5.3.6
make linux
make all test

#!/usr/bin/zsh

# Install Micromamba
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
micromamba self-update

# Install NVM and Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install --lts

# Install Docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

## Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

# Install nvim
curl -sSLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo tar -zxvf nvim-linux64.tar.gz && rm nvim-linux64.tar.gz
sudo ln -s $HOME/nvim-linux64/bin/nvim /usr/bin/nvim

# Install Lua
curl -L -R -O https://www.lua.org/ftp/lua-5.3.6.tar.gz
tar zxf lua-5.3.6.tar.gz
cd lua-5.3.6
make linux
make all test
sudo ln -s $HOME/lua-5.3.6/src/lua /usr/bin/lua

# .dotfiles configuration
git clone https://github.com/HikiJun97/.dotfiles.git

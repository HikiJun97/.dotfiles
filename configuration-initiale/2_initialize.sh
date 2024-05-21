#!/bin/bash

# oh-my-zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# docker installation
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
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

curl -LO https://github.com/neovim/neovim-releases/releases/download/nightly/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz && rm nvim-linux64.tar.gz

echo "alias nv=\"nvim\"" > ~/.zsh_aliases
echo "alias uuu=\"sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get autoremove\"" >> ~/.zsh_aliases
echo "alias install=\"sudo apt-get install -y\"" >> ~/.zsh_aliases
echo "alias installed=\"apt list --installed \| grep\"" >> ~/.zsh_aliases
echo "alias delswp=\"rm ~/.local/share/nvim/swap/*.swp\"" >> ~/.zsh_aliases
echo "mkcd (){" >> ~/.zsh_aliases
echo "	mkdir -p -- \"$1\" && cd -P -- \"$1\"" >> ~/.zsh_aliases
echo "}" >> ~/.zsh_aliases

source ~/.zsh_aliases
source ~/.zshrc


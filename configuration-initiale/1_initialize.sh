#!/bin/bash
sudo apt-get update -y
curl -sL install-node.now.sh/lts | sudo $SHELL
sudo apt install -y build-essential curl wget git bat ca-certificates gnupg zsh universal-ctags
chsh -s `which zsh`
exit

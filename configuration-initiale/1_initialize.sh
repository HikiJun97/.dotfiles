#!/bin/bash
sudo apt-get update -y
sudo apt install -y build-essential libreadline-dev curl wget git bat ca-certificates gnupg zsh universal-ctags
chsh -s `which zsh`
exit

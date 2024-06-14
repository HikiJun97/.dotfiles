#!/usr/bin/zsh

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Zsh Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Configure Zsh aliases
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

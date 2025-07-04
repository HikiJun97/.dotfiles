#!/usr/bin/zsh

# .dotfiles configuration
git clone https://github.com/HikiJun97/.dotfiles.git

# oh-my-zsh
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
sudo ln -s $HOME/lua-5.3.6/src/lua /usr/local/bin/lua

# Install nvim
curl -sSLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo tar -zxvf nvim-linux64.tar.gz && rm nvim-linux64.tar.gz
sudo ln -s $HOME/nvim-linux64/bin/nvim /usr/local/bin/nvim

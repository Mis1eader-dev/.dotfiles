#Make sure everything is up to date
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y



# OpenSSL
sudo apt install -y libssl-dev

# wget
sudo apt install -y wget

# git
sudo apt install -y git

# FUSE
sudo add-apt-repository -y universe
sudo apt install -y libfuse2



# Tmux
sudo apt install -y tmux

# Tmux theme
TMUX_THEME_DIR=~/.local/share/tmux/plugins/tmux-themepack
if ! test -d $TMUX_THEME_DIR; then
	git clone https://github.com/jimeh/tmux-themepack.git $TMUX_THEME_DIR
fi


# Neovim
NEOVIM_BIN_DIR=/usr/bin
NEOVIM_PATH=$NEOVIM_BIN_DIR/nvim
if ! test -f $NEOVIM_PATH; then
	sudo wget -P $NEOVIM_BIN_DIR https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	sudo chmod +x $NEOVIM_BIN_DIR/nvim.appimage
	sudo mv $NEOVIM_BIN_DIR/nvim.appimage $NEOVIM_PATH
fi


# g++
sudo apt install -y g++

# CMake
sudo apt install -y cmake

# Ninja
sudo apt install -y ninja-build



# Clangd for Neovim
sudo apt install -y clangd-15
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-15 100

# Node.js for Coc
if ! which node > /dev/null; then
	curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - &&\
	sudo apt install -y nodejs
fi

# Neovim Packer and Plugins
nvim --headless -c "autocmd User PackerComplete qa" -c "PackerUpdate|PackerCompile"

# Neovim Coc Extensions
sudo apt install -y jq
NEOVIM_COC_EXTENSIONS=$(jq '.dependencies | keys' ~/.config/coc/extensions/package.json | 
	sed 's/\[*\]*\s*"*//g' |
	tr -d '\n' |
	tr ',' ' ')
nvim --headless +"CocInstall -sync $NEOVIM_COC_EXTENSIONS|qa"

# Don't show untracked files
git --git-dir=$HOME/.dotfiles --work-tree=$HOME config status.showUntrackedFiles no

echo "Setup complete"
echo "Make sure to source the bashrc: source ~/.bashrc"

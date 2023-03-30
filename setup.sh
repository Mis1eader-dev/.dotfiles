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
NEOVIM_PATH=/usr/bin/nvim
if ! test -f $NEOVIM_PATH; then
	sudo curl -o $NEOVIM_PATH https://github.com/neovim/neovim/releases/latest/download/nvim.appimage &&\
	sudo chmod +x $NEOVIM_PATH
fi


# g++
sudo apt install -y g++

# CMake
sudo apt install -y cmake

# Ninja
sudo apt install -y ninja-build



# Clangd for Neovim
sudo apt install -y clangd-15

# Node.js for Coc
if ! which node > /dev/null; then
	curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - &&\
	sudo apt install -y nodejs
fi

# Neovim Packer and Plugins
nvim

# Neovim Coc Extensions
#nvim -c "CocUpdate"

# Apply .bashrc
source ~/.bashrc

# Don't show untracked files
dotfiles config status.showUntrackedFiles no

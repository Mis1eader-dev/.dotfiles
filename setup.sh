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

# Neovim
sudo wget -P /usr/bin/ https://github.com/neovim/neovim/releases/latest/download/nvim.appimage &&\
sudo chmod +x /usr/bin/nvim.appimage &&\
sudo mv /usr/bin/nvim.appimage /usr/bin/nvim

# g++
sudo apt install -y g++

# Clangd for Neovim
sudo apt install -y clangd-15

# Node.js
curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - &&\
sudo apt install -y nodejs

# Neovim Packer and Plugins
nvim

# Neovim Coc Extensions
nvim -c "CocUpdate"

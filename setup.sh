# Prompt for Yes/No (Ref: https://gist.github.com/karancode/f43bc93f9e47f53e71fa29eed638243c)
ask() {
    local prompt default reply

    if [[ ${2:-} = 'Y' ]]; then
        prompt='Y/n'
        default='Y'
    elif [[ ${2:-} = 'N' ]]; then
        prompt='y/N'
        default='N'
    else
        prompt='y/n'
        default=''
    fi

    while true; do

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read -r reply </dev/tty

        # Default?
        if [[ -z $reply ]]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}



#Make sure everything is up to date
if ask "Update everything before we start?" Y ; then
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt autoremove -y
fi



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
install_tmux_theme()
{
	# Tmux theme
	TMUX_THEME_DIR=~/.local/share/tmux/plugins/tmux-themepack
	if ! test -d $TMUX_THEME_DIR; then
		git clone https://github.com/jimeh/tmux-themepack.git $TMUX_THEME_DIR
	fi
}
if ! which tmux > /dev/null; then
	if ask "Install Tmux?" Y; then
		sudo apt install -y tmux
		install_tmux_theme
	fi
else
	install_tmux_theme
fi

# The directory for installing binary executables
BIN_DIR=/usr/bin

# Neovim
NEOVIM_PATH=$BIN_DIR/nvim
if ! test -f $NEOVIM_PATH; then
	sudo wget -P $BIN_DIR https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	sudo chmod +x $BIN_DIR/nvim.appimage
	sudo mv $BIN_DIR/nvim.appimage $NEOVIM_PATH
fi



# Languages and Coc Extensions
COC_DEFAULT_EXTENSIONS="coc-json coc-yaml coc-pairs"
COC_EXTENSIONS=""

# C/C++ and build tools
install_c_cpp()
{
	COC_EXTENSIONS+=" coc-clangd coc-cmake"
}
if ! which g++ > /dev/null || ! which cmake > /dev/null || ! which ninja > /dev/null || ! which clangd > /dev/null; then
	if ask "Install C/C++, CMake, and Ninja?" Y; then
		# g++
		sudo apt install -y g++

		# CMake
		sudo apt install -y cmake

		# Ninja
		sudo apt install -y ninja-build

		# Clangd for Neovim
		sudo apt install -y clangd-15
		sudo update-alternatives --install $BIN_DIR/clangd clangd $BIN_DIR/clangd-15 100

		install_c_cpp
	fi
else
	install_c_cpp
fi



# Java
install_java()
{
	COC_EXTENSIONS+=" coc-java"
}
if ! which java > /dev/null || ! which javac > /dev/null; then
	if ask "Install Java?" Y; then
		# OpenJDK
		sudo apt install -y openjdk-19-jdk-headless

		install_java
	fi
else
	install_java
fi



# HTML CSS JS
if ask "Install HTML, CSS, and JS?" Y; then
	COC_EXTENSIONS+=" coc-html coc-css coc-tsserver coc-emmet"
fi


# Python
install_python()
{
	COC_EXTENSIONS+=" coc-pyright"
}
if ! which python > /dev/null; then
	if ask "Install Python?" Y; then
		# Python
		sudo apt install -y python3
		sudo ln -s /bin/python3 /bin/python

		install_python
	fi
else
	install_python
fi



# If at least one programming language is selected
if ! [ -z "$COC_EXTENSIONS" ]; then
	COC_DEFAULT_EXTENSIONS+=" coc-snippets"
fi



# Node.js for Coc
if ! which node > /dev/null; then
	curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - &&\
	sudo apt install -y nodejs
fi

# Neovim Packer and Plugins
echo "Installing Neovim plugins"
nvim --headless +"autocmd User PackerComplete qa"
nvim --headless +"autocmd User PackerComplete qa" +"silent PackerSync"

# Neovim Coc Extensions
#sudo apt install -y jq sed
#COC_EXTENSIONS=$(jq '.dependencies | keys' ~/.config/coc/extensions/package.json | 
#	sed 's/\[*\]*\s*"*//g' |
#	tr -d '\n' |
#	tr ',' ' ')
echo "Installing Neovim Coc extensions"
nvim --headless +"CocInstall -sync $COC_DEFAULT_EXTENSIONS$COC_EXTENSIONS|qa"
#nvim --headless +"CocInstall -sync $COC_EXTENSIONS|qa"

# Don't show untracked files
git --git-dir=$HOME/.dotfiles --work-tree=$HOME config status.showUntrackedFiles no

echo -e "\nSetup complete"
echo -e "Make sure to source the bashrc twice: source ~/.bashrc\n"

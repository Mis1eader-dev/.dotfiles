#!/bin/bash

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

# Curl
sudo apt install -y curl

# wget
#sudo apt install -y wget

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
	sudo curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage --create-dirs -o $NEOVIM_PATH
	sudo chmod +x $NEOVIM_PATH
fi



# Languages and Coc Extensions
COC_EXTENSIONS="coc-json coc-yaml coc-pairs coc-snippets"
# Treesitters
TREESITTERS="json yaml"

# C/C++ and build tools
install_c_cpp()
{
	COC_EXTENSIONS+=" coc-clangd coc-cmake"
	TREESITTERS+=" c cpp cmake"

	# Set the CMake generator to Ninja, in environment variables of .bashrc
	if [[ -z $CMAKE_GENERATOR ]]; then
		echo $'\nexport CMAKE_GENERATOR="Ninja"' >> $HOME/.bashrc
	fi
}
if ! which g++ > /dev/null || ! which cmake > /dev/null || ! which ninja > /dev/null || ! which clangd > /dev/null; then
	if ask $'\nInstall C/C++, CMake, and Ninja?' Y; then
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
	TREESITTERS+=" java"
}
if ! which java > /dev/null || ! which javac > /dev/null; then
	if ask $'\nInstall Java?' Y; then
		# OpenJDK
		sudo apt install -y openjdk-19-jdk-headless

		install_java
	fi
else
	install_java
fi



# HTML CSS JS
if ask $'\nInstall HTML, CSS, and JS?' Y; then
	COC_EXTENSIONS+=" coc-html coc-css coc-tsserver coc-emmet"
	TREESITTERS+=" html css javascript typescript"
fi


# Python
install_python()
{
	COC_EXTENSIONS+=" coc-pyright"
	TREESITTERS+=" python"
}
if ! which python > /dev/null; then
	if ask $'\nInstall Python?' Y; then
		install_python
	fi
else
	install_python
fi



# Lua extensions
install_lua()
{
	COC_EXTENSIONS+=" coc-sumneko-lua"
	TREESITTERS+=" lua"
}
if ! which lua-language-server > /dev/null or ! which $HOME/.config/coc/extensions/coc-lua-data/lua-language-server/bin/lua-language-server > /dev/null; then
	if ask $'\nInstall Lua extensions?' Y; then
		install_lua
	fi

	# Lua
	if ask $'\nInstall Lua (The language, independent from extensions)?' Y; then
		sudo apt install lua5.4
	fi
else
	install_lua
fi



# Node.js for Coc
if ! which node > /dev/null; then
	curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - &&\
	sudo apt install -y nodejs
fi

# Ensure python is installed
sudo apt install -y python3
sudo ln -s /bin/python3 /bin/python
# Ensure pip is installed
sudo apt install -y python3-pip
# Install pynvim for coc-snippets
python -m pip install --user --upgrade pynvim

# Neovim Packer and Plugins
echo "Installing Neovim plugins"
nvim --headless +"autocmd User PackerComplete qa"
echo
nvim --headless +"autocmd User PackerComplete qa" +"silent PackerSync"

# Neovim Coc Extensions
echo -e "\nInstalling Neovim Coc extensions: $COC_EXTENSIONS"
nvim --headless +"CocInstall -sync $COC_EXTENSIONS|qa"



# Neovimm Treesitters
echo -e "\nInstalling Neovim Treesitters: $TREESITTERS"
nvim +"TSInstallSync $TREESITTERS|qa"



# Don't show untracked files and allow credentials to be stored
git --git-dir=$HOME/.dotfiles --work-tree=$HOME config status.showUntrackedFiles no

# Git credentials
if ask "Do you want to provide your git commit name and email?"; then
	while read -p $'\tName: ' GIT_USERNAME && [[ -z $GIT_USERNAME ]]; do :
	done

	while read -p $'\tEmail: ' GIT_EMAIL && [[ -z $GIT_EMAIL ]]; do :
	done

	git config --global user.name "$GIT_USERNAME"
	git config --global user.email "$GIT_EMAIL"
fi
if ask "Allow git credentials to be stored on disk?"; then
	git config --global credential.helper store
fi



# Auto-completion for bash aliases
sudo apt install -y bash-completion
BASH_COMPLETION_PATH=$HOME/.bash_completion
COMPLETE_ALIAS_PATH="~/.config/.complete_alias"
BASH_COMPLETION_DATA=". $COMPLETE_ALIAS_PATH > /dev/null 2>&1"
if ! test -f $BASH_COMPLETION_PATH || ! grep -q "^$BASH_COMPLETION_DATA\$" $BASH_COMPLETION_PATH; then
	echo "$BASH_COMPLETION_DATA" >> $BASH_COMPLETION_PATH
fi



# Platform specific commands to execute
sudo apt install -y grep
FONT_NAME="JetBrainsMono"
FONT_FACE="${FONT_NAME}NL Nerd Font Mono"
FONT_VER="v2.3.3"

# If we are running in WSL
if [[ $(grep -Fi "Microsoft" /proc/version) ]]; then
	# systemd, check if /etc/wsl.conf has the required data for systemd
	WSL_CONF_PATH=/etc/wsl.conf
	WSL_CONF_DATA=$'[boot]\nsystemd=true'
	if ! test -f $WSL_CONF_PATH || [[ $(< $WSL_CONF_PATH) != "$WSL_CONF_DATA" ]]; then
		echo "$WSL_CONF_DATA" | sudo tee $WSL_CONF_PATH > /dev/null
	fi

	# TODO: Either show them where to download and install, then
	# set their terminal settings font to JetBrainsMonoNL Nerd Font Mono
	# Or interact with windows through here
	
	echo $'\nChange the font of the terminal by going to: Terminal > Settings (CTRL + ,) > Profile > Additional settings > Appearance'
	echo "- Font: $FONT_FACE"
	echo "- Font Size: 12"
	echo "- Font Weight: Medium"

# If it is pure linux
else
	# JetBrainsMono font
	FONTS_DIR=/usr/local/share/fonts
	FONT_PATH=$FONTS_DIR/$FONT_NAME
	
	# Allow fonts to be installed with `fc-cache -fv`
	sudo apt install -y fontconfig

	# If the font already exists
	if ! fc-list : family | sort | uniq | grep -q "$FONT_FACE" && ! test -d $FONT_PATH; then
		FONT_ZIP_FILE=$FONT_PATH.zip
		curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/$FONT_VER/$FONT_NAME.zip --create-dirs -o $FONT_ZIP_FILE

		# unzip
		sudo apt install -y unzip
		unzip $FONT_ZIP_FILE -d $FONT_PATH
		rm $FONT_ZIP_FILE

		# Add the font
		fc-cache -fv
	fi

	echo $'\nChange the font of the terminal by going to: Terminal > Preferences > Profile > Text > Custom font'
	echo "- Font: $FONT_FACE"
	echo "- Font Size: 12"
	echo "- Font Weight: Medium"
fi



# Add our custom .profile on top of the existing .profile, by sourcing
PROFILE_PATH="~/.config/.profile"
PROFILE_DATA=". $PROFILE_PATH"
PROFILE_DEFAULT_PATH=$HOME/.profile
if ! test -f $PROFILE_DEFAULT_PATH || ! grep -q "^$PROFILE_DATA\$" $PROFILE_DEFAULT_PATH; then
	echo "$PROFILE_DATA" >> $PROFILE_DEFAULT_PATH
fi



# Add our custom .bashrc on top of the existing .bashrc, by sourcing
BASHRC_PATH="~/.config/.bashrc"
BASHRC_DATA=". $BASHRC_PATH"
BASHRC_DEFAULT_PATH=$HOME/.bashrc
if ! test -f $BASHRC_DEFAULT_PATH || ! grep -q "^$BASHRC_DATA\$" $BASHRC_DEFAULT_PATH; then
	echo "$BASHRC_DATA" >> $BASHRC_DEFAULT_PATH
fi



# Finish
echo $'\nSetup complete'
read -p "Press enter to finish"
echo
. $HOME/.bashrc

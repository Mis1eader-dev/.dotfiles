```
# Clone the repository
git clone --mirror https://github.com/Mis1eader-dev/.dotfiles.git $HOME/.dotfiles

# Bring out the files
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout -f

# Execute the setup
~/setup.sh

# Source .bashrc
source ~/.bashrc
```

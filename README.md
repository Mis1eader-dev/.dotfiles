```sh
# Clone the repository
git clone --mirror https://github.com/Mis1eader-dev/.dotfiles.git $HOME/.dotfiles

# Make the bare repo accessed via an alias
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

# Make it sparse
dotfiles config core.sparsecheckout true

# Don't clone README.md
echo $'/*\n!README.md' > $HOME/.dotfiles/info/sparse-checkout

# Bring out the files
dotfiles checkout -f

# Execute the setup
~/setup.sh

# Source .bashrc
source ~/.bashrc
```

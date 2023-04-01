<h1 align="center">Installation</h1>

```sh
# Extract path
DOTFILES=$HOME/.dotfiles

# Clone the repository
git clone --mirror https://github.com/Mis1eader-dev/.dotfiles.git $DOTFILES

# Make the bare repo accessed via an alias
alias dotfiles="git --git-dir=$DOTFILES --work-tree=$HOME"

# Make it sparse
dotfiles config core.sparsecheckout true

# Don't clone README.md
echo $'/*\n!README.md' > $DOTFILES/info/sparse-checkout

# Bring out the files
dotfiles checkout -f

# We are done with it
unset DOTFILES

# Execute the setup
~/setup.sh

# Source .bashrc
source ~/.bashrc
```

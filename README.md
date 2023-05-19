<h1 align="center">Installation</h1>

```sh
# Git path
DOTFILES=$HOME/.dotfiles

# Clone the repository
git clone --mirror https://github.com/Mis1eader-dev/.dotfiles.git $DOTFILES

# Make the bare repo accessed via an alias
alias dotfiles="git --git-dir=$DOTFILES --work-tree=$HOME"

# Make it sparse
dotfiles config core.sparsecheckout true

# Don't clone README.md
echo $'/*\n!README.md' > $DOTFILES/info/sparse-checkout

# Bring in the files
dotfiles checkout -f

# We are done with it
unset DOTFILES

# Source and execute the setup
. ~/setup.sh
```

<br>

# What will be installed
- `libssl-dev`
- `curl`
- `git`
- `libfuse2` - For running AppImages
- `tmux` (Optional)
  - `jimeh/tmux-themepack`
- `neovim`
  - `wbthomason/packer.nvim` - Plugin manager
  - `Mofiqul/vscode.nvim` - VSCode Dark+ theme
  - `neoclide/coc.nvim` - Auto completion
    - `coc-json`
    - `coc-yaml`
    - `coc-pairs`
    - `coc-snippets`
    - Others depending on whether that language is installed
  - `nvim-treesitter/nvim-treesitter`
    - `json`
    - `yaml`
    - Others depending on whether that language is installed
  - `nvim-lualine/lualine.nvim` - Status line and tabline
  - `nvim-tree/nvim-web-devicons`
  - `vim-utils/vim-man` - Man pages
  - `folke/todo-comments.nvim`
- C/C++ (Optional)
  - `g++`
  - `cmake`
    - Sets `CMAKE_EXPORT_COMPILE_COMMANDS` to 1, all CMake projects will create `compile_commands.json` automatically
  - `ninja-build`
    - Sets `CMAKE_GENERATOR` environment variable to Ninja, all CMake projects will be built with Ninja
  - `clangd-15`
  - Coc extensions:
    - `coc-clangd`
    - `coc-cmake`
  - Treesitters:
    - `c`
    - `cpp`
    - `cmake`
- Java (Optional)
  - `openjdk-19-jdk-headless`
  - Coc extensions:
    - `coc-java`
  - Treesitters:
    - `java`
- HTML, CSS, JS (Optional)
  - `live-server` - To make documents hot refresh
  - Coc extensions:
    - `coc-html`
    - `coc-css`
    - `coc-tsserver`
    - `coc-emmet`
  - Treesitters:
    - `html`
    - `css`
    - `javascript`
    - `typescript`
- Python (Optional)
  - Regardless of whether Python is chosen to be installed, Python and pip will be installed later
  - Coc extensions:
    - `coc-pyright`
  - Treesitters:
    - `python`
- Lua (Optional)
  - `lua5.4` (Optional)
  - Coc extensions:
    - `coc-sumneko-lua`
  - Treesitters:
    - `lua`
- `nodejs` - Needed for `coc.nvim`
- `python3`
- `python3-pip`
- `pynvim` - Needed for `coc-snippets`
- `bash-completion` - Auto-completion for bash commands
- `cykerway/complete-alias`
  - In `.config/.complete_alias` by default it is set to auto-complete all aliases
- `grep` - Regular expressions (regex)
- [JetBrainsMono v2.3.3](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip) Font
  - On a non-Windows machine it also installs:
    - `fontconfig`
    - `unzip` (If the font isn't already installed)

<br>

# Bash aliases
Set according to `.config/.bashrc`, by default:
- `v` - Launchs neovim
- `dotfiles` - Acts on this repository, using git
- `see` - Opens file explorer on Windows, or opens the browser if an HTML file is given to it
- `sdown` - Shutdown
- `gi` - `git init`
- `gs` - `git status`
- `ga` - `git add`
- `gc` - `git commit`
- `gca` - `gc -a`
- `gp` - `git push`
- `gpl` - `git pull`
- `gb` - `git branch`
- `gba` - `gb -a`
- `gch` - `git checkout`
- `gm` - `git merge`

<br>

# neovim
All key bindings are defaults, and two are added:
- `CTRL+w |` - Split horizontally
- `CTRL+w -` - Split vertically

# tmux
All key bindings are defaults, except for splits, they are rebound to:
- `CTRL+b |` - Split horizontally
- `CTRL+b -` - Split vertically
- `CTRL+b b` - Show/hide status line

<br>

# Symlinks
These are made by the `setup.sh`, not accounting for other symlinks made by package installations
- `clangd` -> `clangd-15`
- `python` -> `python3`

<br>

# WSL
On Windows Subsystem for Linux it enables `systemd`, takes effect after a reboot

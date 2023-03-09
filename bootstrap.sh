#!/usr/bin/env zsh

cp ./.zshrc ./.zsh_aliases ~/

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install apps from file
xargs brew install < brew_apps.txt 

# install apps via cask from file
xargs brew install --cask < brew_cask_apps.txt

# use brew to auto-start mariaDB
brew services start mariadb

# source files
source ~/.zprofile ~/.zshrc
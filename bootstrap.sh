#!/usr/bin/env zsh

read -q "REPLY?Override .zshrc and .zsh_aliases file in home directory [Y/n] " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  cp ./.zshrc ./.zsh_aliases ~/
else
  echo ".zshrc and .zsh_aliases are not overriden!"
fi

read -q "REPLY?Install brew [Y/n] " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew not installed"
fi

read -q "REPLY?Install apps [Y/n] " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # install apps from file
  xargs brew install < brew_apps.txt

  # install apps via cask from file
  xargs brew install --cask < brew_cask_apps.txt
else
  echo "Apps not installed"
fi

read -q "REPLY?Run mariadb as service [Y/n] " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  brew services start mariadb
else
  echo "Maria service not added"
fi



# source files
source ~/.zprofile ~/.zshrc
#!/usr/bin/env zsh

read -q "REPLY?Override .zshrc and .zsh_aliases file in home directory [Y/n] " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cp ./.zshrc ./.zsh_aliases ~/
else
  echo ".zshrc and .zsh_aliases are not overridden!"
fi

#read -q "REPLY?Install brew [Y/n] " -r
#echo
#if [[ $REPLY =~ ^[Yy]$ ]]; then
#  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#else
#  echo "Skipped Homebrew installation"
#fi

brew_location="which brew"
if [ "$brew_location" = "" ]; then
  echo '/bin/bash -c $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo 'brew upgrade'
  brew upgrade
fi


read -q "REPLY?Install apps [Y/n] " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # install apps from file
  xargs brew install < brew_apps.txt

  # install apps via cask from file
  xargs brew install --cask < brew_cask_apps.txt
else
  echo "Skipped apps installation"
fi

read -q "REPLY?Do nvm/npm setup steps [Y/n] " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo 'mkdir ~/.nvm'
  mkdir ~/.nvm
  echo '$(brew --prefix nvm)/nvm.sh'
  source "$(brew --prefix nvm)/nvm.sh"
  echo "source $(brew --prefix nvm)/nvm.sh" >> ~/.zshrc
  echo 'nvm install --lts'
  nvm install --lts
  echo 'install -g npm@latest'
  npm install -g npm@latest
else
  echo "Skipped nvm setup"
fi

read -q "REPLY?Run mariadb as service [Y/n] " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  brew services start mariadb
else
  echo "Skipped Maria service"
fi

# source files
source "/Users/$USER/.zprofile"
source "/Users/$USER/.zshrc"

#!/usr/bin/env zsh

read -q "REPLY?Override .zshrc and .zsh_aliases file in home directory [Y/n] " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Make backup of ~/.zshrc"
  echo "cp ~/.zshrc ~/.zshrc.pre-mac-setup"
  cp ~/.zshrc ~/.zshrc.pre-mac-setup
  
  echo "Copy files to user directory"
  echo "cp ./.zshrc ./.zsh_aliases ~/"
  cp ./.zshrc ./.zsh_aliases ~/
else
  echo ".zshrc and .zsh_aliases are not overridden!"
fi

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

read -q "REPLY?Set up Docker zsh autocompletion [Y/n] " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "etc=/Applications/Docker.app/Contents/Resources/etc"
  etc=/Applications/Docker.app/Contents/Resources/etc
  echo 'ln -s $etc/docker.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker'
  ln -s $etc/docker.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker
  echo 'ln -s $etc/docker-machine.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker-machine'
  ln -s $etc/docker-machine.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker-machine
  echo 'ln -s $etc/docker-compose.zsh-completion $(brew --prefix)/zsh/site-functions/_docker-compose'
  ln -s $etc/docker-compose.zsh-completion $(brew --prefix)/zsh/site-functions/_docker-compose
else
  echo "Skipped docker zsh autocompletion"
fi

# source files
source "/Users/$USER/.zprofile"
source "/Users/$USER/.zshrc"

read -q "REPLY?Install oh-my-zsh [Y/n] " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  mv ~/.zsh_aliases ~/.oh-my-zsh/custom/aliases.zsh
  cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  sed -i '' 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting docker docker-machine docker-compose npm nvm brew jenv aws)/g' ~/.zshrc
  exec zsh -l
else
  echo "Skipped oh-my-zsh installation"
fi

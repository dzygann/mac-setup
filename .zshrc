# export definitions
if [ -f ~/.zsh_export ]; then
	. ~/.zsh_export
fi

# alias definitions
if [ -f ~/.zsh_aliases ]; then
	. ~/.zsh_aliases
fi

# add autocompletion to brew
if type brew &>/dev/null
then
	FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# add autocompletion
autoload -Uz compinit && compinit

# activate jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# add nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# Load Angular CLI autocompletion
source <(ng completion script)


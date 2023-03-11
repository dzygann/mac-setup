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

# Load Angular CLI autocompletion
# source <(ng completion script)


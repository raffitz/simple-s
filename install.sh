#!/bin/sh

# simple-s prompt for zsh
# install script

set -e

if [ "$1" = "nosudo" ]; then
	echo "Copying script file..."
	cp prompt_simple-s_setup $HOME/.zshprompt

	echo "Sourcing prompt file in .zshrc ..."
	printf "\n\n# Added by simple-s install script\nsource $HOME/.zshprompt\n" >> ~/.zshrc
else
	echo "Copying script file..."
	sudo cp prompt_simple-s_setup /usr/share/zsh/functions/Prompts

	echo "Adding prompt to .zshrc ..."
	printf "\n\n# Added by simple-s install script\nautoload -Uz promptinit\npromptinit\nprompt simple-s\n" >> ~/.zshrc
fi


# -*- mode: sh -*-
#
# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.dotfiles/oh-my-zsh
ZSH_CUSTOM=$HOME/.dotfiles/oh-my-zsh-custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="fino-light"

# My aliases
alias make='nocorrect make'
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias m="nocorrect make -j3 -k"
alias v="valgrind --tool=memcheck --track-origins=yes  --show-reachable=yes --error-limit=no"
alias lf="ls -hltra"
alias cls='printf "\033c"' # clear screen

alias rm="trash"
if ! type "trash" > /dev/null; then
  echo "trash not installed. Falling back to actual rm."
  alias rm="rm"
fi

export ALTERNATE_EDITOR="" # Should start emacs --daemon if emacsclient runs without one.
alias e='emacsclient -t'
alias ec='emacsclient -c'

# oh-my-zsh options
DISABLE_CORRECTION="true"
DISABLE_AUTO_UPDATE="true"

# Plugins to be loaded
plugins=(git github screen dev-profile keychain archlinux battery ssh-agent autojump history-substring-search taskwarrior)

setopt autocd

# Unset shared history
unsetopt share_history

if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

source $ZSH/oh-my-zsh.sh

# -*- mode: sh -*-

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.dotfiles/.zprezto

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

setopt autocd

# Don't print job information (e.g. fork pids)
set +m

#autoload zmv

# Unset shared history
#unsetopt share_history

if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


# Bindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward

# -*- shell-script -*-
#
# This file is sourced on all invocations of the shell.
# If the -f flag is present or if the NO_RCS option is
# set within this file, all other initialization files
# are skipped.
#
# This file should contain commands to set the command
# search path, plus other important environment variables.
# This file should not contain commands that produce
# output or assume the shell is attached to a tty.
#
# Global Order: zshenv, zprofile, zshrc, zlogin

export PAGER='less -R'
export REPLYTO=$EMAIL
export MAIL=$HOME/Mail

# Tools
export EDITOR='vim'
export MAIL="/var/mail/$USER"

# Find the first available terminal
term_arr=("termite" "urxvt" "terminator" "gnome-terminal" "xterm")
for t in "${term_arr[@]}"
do
  if command -v $t >/dev/null; then
    # This is used by i3-sensible-terminal
    export TERMINAL=$t
    break
  fi
done

# Terminal (vim + tmux)
export TERM=xterm-256color
if [ "$TMUX" != "" ]; then
  # Fix term type
  export TERM=screen-256color

  # Fix ctrl+S in tmux with vim
  stty stop undef
fi

apt_pref='apt-get'

# Python
export PYTHONSTARTUP=$HOME/.pythonrc.py

# Useful aliases
alias m="make -j8"
alias v="valgrind --tool=memcheck --track-origins=yes  --show-reachable=yes --error-limit=no"

# Enable GCC coloring (GCC >= 4.9)
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Report CPU usage for commands running longer than 10 seconds
REPORTTIME=10

# Watch people logging on the machine (except the current user)
watch=(notme)


# If glances installed
if type "glances" > /dev/null; then
  alias glances="glances -b --process-short-name --disable-process-extended -1"
fi

# Use local .zshenv
if [ -f ~/.zshenv.local ]; then
    source ~/.zshenv.local
fi

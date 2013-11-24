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

# Terminal (vim + tmux)
export TERM=xterm-256color

apt_pref='apt-get'

dotfiles
========

Configuration files and utilities for my Linux system.

## Install

```sh
cd ~
git clone --recursive https://github.com/bchretien/dotfiles.git .dotfiles
cd .dotfiles
./setup.sh
```
## Configuration

The only files that have to be modified are:
* [.gitconfig.local]() (name and e-mail address for Git)
* [.zprofile.local]() (local .zprofile, i.e. put the code that starts the X Window System etc.)
* [.zshenv.local]() (exported variables: paths, $EDITOR, etc.)
* [.zshrc.local]() (local .zshrc, to change the theme etc.)

## Dependencies

Required:
* Git

Supported:
* conky
* gpg
* tmux
* vim
* zsh

Dependencies:
* exuberant-ctags
* autojump
* ack


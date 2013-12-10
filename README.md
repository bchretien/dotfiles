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

The only file that has to be modified is [.gitconfig.local][1] (name and e-mail address for Git).

## Dependencies

Required:
* Git

Supported:
* zsh
* vim
* tmux
* exuberant-ctags
* autojump
* ack

[1]: .gitconfig.local

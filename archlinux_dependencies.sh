#!/bin/bash

# Install official dependencies
sudo pacman -S zsh git autojump gvim tmux ctags ack

# Install AUR dependencies
yaourt --noconfirm libtinfo

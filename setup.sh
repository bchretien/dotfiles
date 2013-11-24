#!/bin/sh
# Based on Thomas Moulard's setup script:
# https://github.com/thomas-moulard/dotfiles

set -e

if ! `test x$(basename $(pwd)) = x.dotfiles`; then
 echo "please run ./setup.sh from .dotfiles directory"
 exit 1
fi

# Install spf13-vim
echo "Installing spf13-vim..."
cd spf13-vim
./bootstrap.sh
cd ..

dotfiles=`find . -maxdepth 1 -type f -and -name '.*'`
for i in $dotfiles; do
 ln -sf `pwd`/$i $HOME/$i
done

ln -sf `pwd`/.emacs.d ~/.emacs.d

# Create directories if necessary
mkdir ~/.ssh 2> /dev/null || true
mkdir ~/.gnupg 2> /dev/null || true

echo "Symbolic links have been created successfully"


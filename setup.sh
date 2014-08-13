#!/bin/sh
# Based on Thomas Moulard's setup script:
# https://github.com/thomas-moulard/dotfiles

set -e

if ! `test x$(basename $(pwd)) = x.dotfiles`; then
    echo "please run ./setup.sh from .dotfiles directory"
    exit 1
fi

# Default variables
install_vim=true

git submodule init
git submodule update --recursive

# Files ending with .ini are copied if they do not already exist
inifiles=`find . -maxdepth 1 -type f -and -name '*.ini'`
for i in $inifiles; do
    new_name=${i%.ini}
    if [ ! -f $new_name ]; then
        cp $i $new_name
    fi
done

# Files starting with .
dotfiles=`find . -maxdepth 1 -type f -and -name '.*' -and -not -name '*.ini'`
for i in $dotfiles; do
    # ./.filename becomes .filename
    ii=${i#./}
    ln -sf `pwd`/$ii $HOME/$ii
done

# Links starting with .
dotlinks=`find . -maxdepth 1 -type l -and -name '.*'`
for i in $dotlinks; do
    # ./.filename becomes .filename
    ii=${i#./}
    ln -sf `pwd`/$ii $HOME/$ii
done

# Directories starting with . (except . and .git)
dotdirs=`find . -maxdepth 1 -type d -and -name '.*' -and -not \( -path "./.git" -o -path "." \)`
for i in $dotdirs; do
    # ./.dirname becomes .dirname
    ii=${i#./}
    echo $ii
    if [ ! -d "`pwd`/$ii" ]; then
        ln -sf `pwd`/$ii $HOME/$ii

        # TODO: else ask the user if he wants to remove the directory to replace it
    fi
done

# Directories in config
config_dirs=`find ./config -mindepth 1 -type f -and -not -name '*.ini'`
for i in $config_dirs; do
    # ./config/dir/filename becomes config/dir/filename
    ii=${i#./}

    # Create parent directories if needed
    mkdir -p $HOME/.${ii%/*}

    # Create link
    ln -sf `pwd`/$ii $HOME/.$ii
done

# For ini files in config
config_inifiles=`find ./config -maxdepth 1 -type f -and -name '*.ini'`
for i in $config_inifiles; do
    ii=${i#./}
    new_name=${ii%.ini}

    # Copy ini file if does not already exist
    if [ ! -f $new_name ]; then
        cp $i $new_name
    fi

    # Create link if target file does not exist
    if [ ! -f $new_name ]; then
      ln -sf `pwd`/$new_name $HOME/.$new_name
    fi
done

if [ "$install_vim" = true ]; then
    # Install spf13-vim
    if [[ -L ~/.vimrc ]] && [[ "$(readlink ~/.vimrc)" = "$HOME/.spf13-vim-3/.vimrc" ]]; then
      echo "Updating spf13-vim..."
      vim +BundleInstall! +BundleClean +qall
    else
      echo "Installing spf13-vim..."
      cd spf13-vim
      ./bootstrap.sh
      cd ..
    fi

    # Compile YouCompleteMe for vim
    ./compile_youcompleteme.sh

    # Add custom snippets
    ln -sf `pwd`/custom_snippets $HOME/.vim/bundle/vim-snippets/
fi

# Create directories if necessary
mkdir ~/.ssh 2> /dev/null || true
mkdir ~/.gnupg 2> /dev/null || true

echo "Symbolic links have been created successfully"

# Load fonts
fc-cache -vf ~/.fonts
echo "Powerline fonts have been cached. If using vim in a terminal, close all open terminal windows."

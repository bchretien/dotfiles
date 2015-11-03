#!/bin/sh

set -e

dotdir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)/..

# Files ending with .ini are copied if they do not already exist
inifiles=`find $dotdir $dotdir/term/zsh -maxdepth 1 -type f -and -name '*.ini'`
for i in $inifiles; do
  new_name=${i%.ini}
  if [ ! -f $new_name ]; then
    cp $i $new_name
  fi
done


# For ini files in config
config_inifiles=`find $dotdir/config -maxdepth 1 -type f -and -name '*.ini'`
for i in $config_inifiles; do
  ii=${i#./}
  new_name=${ii%.ini}

  # Copy ini file if does not already exist
  if [ ! -f $new_name ]; then
    cp $i $new_name
  fi

  # Linking done by dotbot
done

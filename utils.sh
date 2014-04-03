#!/bin/sh
# A bunch of shell utility functions

# command_exists function from YouCompleteMe's install.sh script
function command_exists {
  hash "$1" 2>/dev/null ;
}

# num_cores function from YouCompleteMe's install.sh script
function num_cores {
  if command_exists nproc; then
   num_cpus=$(nproc)
  else
    num_cpus=1
    if [[ `uname -s` == "Linux" ]]; then
      num_cpus=$(grep -c ^processor /proc/cpuinfo)
    else
      # Works on Mac and FreeBSD
      num_cpus=$(sysctl -n hw.ncpu)
    fi
  fi
  echo $num_cpus
}

function check_distribution {
  echo `lsb_release -is`
}

# List all files owned by a given package
function list_package_files {
  # Debian/Ubuntu: apt-file list $1
  # Arch Linux: pacman -Qql $1
  distrib=`check_distribution`
  if [ "$distrib" == "Arch" ]; then
    name=$1
    # If package with given name cannot be found
    if ! (( $(pacman -Q $1 &>/dev/null) )) ; then
      # $1 not found, try to find git, hg or svn version
      name=`pacman -Qqs $1 | grep "$1-" | grep -E "hg|git|svn"`
      if [ -z "$name" ]; then
        exit 2
      fi
    fi
    echo 'pacman -Qql ' $name
  elif [ "$distrib" == "Debian" || "$distrib" == "Ubuntu" ]; then
    echo 'apt-file list ' $1
  fi
}

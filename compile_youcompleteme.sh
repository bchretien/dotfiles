#!/bin/sh
cd ~/.spf13-vim-3/.vim/bundle/YouCompleteMe/

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

# Create build directory
mkdir -p build && cd build

# Run CMake
cmake -G "Unix Makefiles" -DUSE_SYSTEM_LIBCLANG=ON ../cpp

# Build libraries
make -j$(num_cores) ycm_core
make -j$(num_cores) ycm_support_libs

# Libraries should automatically be added to ../python in build
cd 

#!/bin/sh
source ./utils.sh

cd ~/.spf13-vim-3/.vim/bundle/YouCompleteMe/

# Create build directory
mkdir -p build && cd build

# Run CMake
cmake -G "Unix Makefiles" -DUSE_SYSTEM_LIBCLANG=ON ../cpp

# Build libraries
make -j$(num_cores) ycm_core
make -j$(num_cores) ycm_support_libs

# Libraries should automatically be added to ../python in build
cd 

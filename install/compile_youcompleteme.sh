#!/bin/sh
source ./lib/utils.sh

cd ~/.spf13-vim-3/.vim/bundle/YouCompleteMe/third_party/ycmd

# Create build directory
mkdir -p build && cd build

# Run CMake
cmake ../cpp -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release \
   -DUSE_SYSTEM_LIBCLANG=ON \
   -DUSE_CLANG_COMPLETER=ON

# Build libraries
make -j$(num_cores) ycm_core
make -j$(num_cores) ycm_support_libs

# Libraries should automatically be added to ../python in build
cd 

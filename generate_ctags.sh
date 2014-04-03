#!/bin/sh
# Generate ctags for system headers:
#  - Boost
#  - Eigen3
# See: http://stackoverflow.com/questions/2825464/generating-a-reasonable-ctags-database-for-boost

source ./utils.sh

mkdir -p ~/.vim/tags

if command_exists ctags; then
  echo "Generating ctags for Boost"
  filelist=$(list_package_files boost)
  $filelist | grep -E -o "/usr/include/.*\.(h|hpp)" \
            | grep -v "/usr/include/boost/typeof/" \
            > ~/.vim/tags/boost-filelist
  ctags --sort=foldcase --c++-kinds=+p --fields=+iaS --extra=+q \
    -f ~/.vim/tags/boost -L ~/.vim/tags/boost-filelist

  echo "Generating ctags for Eigen"
  filelist=$(list_package_files eigen3)
  $filelist | grep -E -o "/usr/include/eigen3/.*\.(h|hpp)" \
            > ~/.vim/tags/eigen3-filelist
  ctags --sort=foldcase --c++-kinds=+p --fields=+iaS --extra=+q \
    -f ~/.vim/tags/eigen3 -L ~/.vim/tags/eigen3-filelist
else
  echo "ctags not installed, skipping tag generation."
fi


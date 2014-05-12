#!/bin/sh
# Generate ctags for system headers:
#  - Boost
#  - Eigen3
#  - other user-defined folders (args)
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
  filelist=$(list_package_files eigen)
  $filelist | grep -E -o "/usr/include/eigen3/.*\.(h|hpp)" \
            > ~/.vim/tags/eigen3-filelist
  ctags --sort=foldcase --c++-kinds=+p --fields=+iaS --extra=+q \
    -f ~/.vim/tags/eigen3 -L ~/.vim/tags/eigen3-filelist

  # Generating ctags for other user-defined folders
  for dir_path in "$@"
  do
    if [ -d "$dir_path" ]; then
      echo "Generating ctags for" $dir_path
      name=$(basename "$dir_path")
      write_file=true
      # If the ctags file already exists, ask for confirmation
      if [ -f "$HOME/.vim/tags/$name" ]; then
        while true; do
          read -p "~/.vim/tags/$name exists. Do you wish to overwrite it? [yn]" yn
          case $yn in
            [Yy]* ) write_file=true; break;;
            [Nn]* ) write_file=false; break;;
                * ) echo "Please answer 'y' (yes) or 'n' (no).";;
          esac
        done
      fi
      if [ "$write_file" == true ]; then
        find "$dir_path" -type f -regex ".*\.\(h\|hh\|hpp\|hxx\)" \
          > ~/.vim/tags/$name-filelist
        ctags --sort=foldcase --c++-kinds=+p --fields=+iaS --extra=+q \
          -f ~/.vim/tags/$name -L ~/.vim/tags/$name-filelist
      else
        echo "Skipping tags for $dir_path"
      fi
    fi
  done
else
  echo "ctags not installed, skipping tag generation."
fi


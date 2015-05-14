# ![dotfiles](https://raw.githubusercontent.com/bchretien/dotfiles/master/.images/dotfiles.png)

Configuration files and utilities for my Linux system.

Relies on [Dotbot](https://github.com/anishathalye/dotbot) for dotfiles
installation.

## Dependencies

Required:
* Git
* Python (Dotbot)

## Install

```sh
cd ~
git clone --recursive https://github.com/bchretien/dotfiles.git .dotfiles
cd .dotfiles
./install
```

The `install` command can safely be run multiple times.

## Configuration

The only files that have to be modified are:
* [~/.hgrc.local]() (name and e-mail address for Mercurial)
* [~/.gitconfig.local]() (name and e-mail address for Git)
* [~/.zprofile.local]() (local `.zprofile`, i.e. put the code that starts
  the X Window System etc.)
* [~/.zshenv.local]() (exported variables: paths, `$EDITOR`, etc.)
* [~/.zshrc.local]() (local `.zshrc`, to change the theme etc.)

## Organization

Dotfiles are organized in multiple directories:

### dev

Files related to software development and version control systems.

Currently supported:

* Git (aliases, default options),
* Mercurial (default options),
* GDB (custom `.gdb_init` for improved GDB interface),
* LaTeX (`LaTeX-Mk` support),
* Python (interactive shell).

### editor

Files related to text editors or IDEs.

Currently supported:

* Vim (tons of options, plugins, etc.),
* Emacs (basic settings).

### gui

Files related to window managers, X11, etc.

Currently supported:

* i3 (i3 config with i3blocks),
* X11 configuration,
* GTK2 theme.


### media

Files related to media players (music, video).

Currently supported:

* mpd,
* ncmpcpp.

### term

Files related to terminal emulators and multiplexers.

Currently supported:

* fzf,
* tmux (config and plugins),
* weechat,
* zsh (config based on prezto).

### util

Files related to utility software that did not fit in the other categories.

Currently supported:

* gnupg,
* fonts (patched fonts for Powerline users).


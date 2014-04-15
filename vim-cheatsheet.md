# Vim Cheatsheet

Original file from [Andrew Pennebaker](https://github.com/mcandre/dotfiles/blob/master/vim-cheatsheet.md)

## Documentation

[Emergency vi](http://ergoemacs.org/emacs/emergency_vi.html)

[Vim Tips Wiki](http://vim.wikia.com/wiki/Vim_Tips_Wiki)

[vi and Vim Editors Pocket Reference](http://shop.oreilly.com/product/0636920010913.do)

[Vim Genius](http://vimgenius.com/)

[VIM Adventures](http://vim-adventures.com/)

[The Vi Lovers Home Page](http://thomer.com/vi/vi.html)

## Install

    On Debian/Ubuntu:
    $ sudo apt-get install vim

    On Arch Linux:
    $ sudo pacman -S vim

By default, Ubuntu uses the `vim.tiny`, which lacks support for arrow key navigation. Use `apt-get install vim` to upgrade to full `vim` with arrow key support.


## Configure

In these dotfiles:

    ~/.vimrc.local
    ~/.vimrc.before.local
    ~/.vimrc.bundles.local

## Repositories

[Vundle](https://github.com/gmarik/vundle)

# Basic Commands

## Modes

### Normal

By default, Vim begins in Normal mode, for entering commands. To issue a command, type `Colon`, then the command, then `Enter`. This is represented in Vim documentation with the notation `:command`.

### Insert

From Normal mode, press `i` to switch to Insert mode. Then begin typing text.

To return to Normal mode, press `ESC`.

### Visual

From Normal mode, press `v` to switch to Visual mode.

To return to Normal mode, press `ESC`.

### Open File/Directory

    $ vim <file/dir>

    $ vim
    :e <file/dir>

### View File

    $ view <file/dir>

### Save

    :w

### Save As...

    :o

### Quit

    :q

### Force Quit

    :q!

### Undo

    u

### Redo

    <ctrl> + R

### Cancel Vim Command Chain

    ESC

### Next Search Result

    n

### Find

    /<term>

`n` next match.

### Replace

    :s/<term>/<replacement>/g

### Search in Directory

    :grep <term> *.?<file extensions>

### Copy Lines

    yy[n]

### Paste Lines

    p

# Navigation

## Move Cursor

Arrow keys require full `vim` package.

### Left (Visual)

    h

### Down (Visual)

    j

### Up (Visual)

    k

### Right (Visual)

    l

### Start of Line

    I

### End of Line

    A

### Go to Line

    :<n>

### Insert Line Below

    o

### Insert Line Above

    O

### Delete

    x

    <ctrl> + D

### Go to previous position (in stack)

    <ctrl> + o

### Go to next position (in stack)

    <ctrl> + i

### End of File

    G

### Go to next same word on cursor

    gd

# Help

    :h '<term>

# Windows

### Split Windows

    <ctrl> + W, S

### Switch Window

    <ctrl> + W, <ctrl> + W

### Close Window

    :hide

# Development

### Jump to function definition

    gd

### Reflow the current paragraph to fit within 80 characters

    gqap

# Miscellaneous

### Type digraphs (e.g. subscript, superscript) in insert mode

    <ctrl> + K, <digraph code>

#### Example: type ² and ₃

    <ctrl> + K, 22
    <ctrl> + K, s3

# Plugins

## ctrlp.vim

### Toggle ctrlp (file loader)

    <ctrl> + p

### To mark/unmark multiple files

    <ctrl> + z

## Vim-CtrlSpace

### Toggle

    <ctrl> + space

### Open file

    e
    E

### Save workspace

    S

### Load workspace

    L

## EasyAlign

### Align selected text around =

    <Enter>=

#### Example: align paragraph around =

    vip<Enter>=

## EasyMotion

### Move forward

    <leader><leader>w

### Move backward

    <leader><leader>b

## DoxygenToolkit

### Generate Doxygen block for current function

    <leader>d
    :Dox

## Tagbar

### Toggle tag bar

    <leader>tt

## vim-dragvisuals

### Move block of selected text

    h, j, k, l

### Duplicate block of selected text

    D

## UltiSnips

### Load snippet

    [snippet name]<tab>

### Jump to next part of snippet

    <tab>

### Jump to previous part of snippet

    <shift> + <tab>

## Undotree

### Trigger Undotree

    <leader>u

## vim-multiple-cursors

### Select multiple words

    <ctrl> + n

## YankStack

### Cycle backwards through your history of yanks

    <alt> p

### Cycle forwards through your history of yanks

    <alt> P

" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker spell:
"
" Some of the settings come from spf13-vim: https://github.com/spf13/spf13-vim
"

" Environment {{{
  " This must be first, because it changes other options as side effect
  set nocompatible

  " Identify platform {{{
    silent function! OSX()
      return has('macunix')
    endfunction
    silent function! LINUX()
      return has('unix') && !has('macunix') && !has('win32unix')
    endfunction
    silent function! WINDOWS()
      return (has('win16') || has('win32') || has('win64'))
    endfunction
  " }}}
" }}}

" Use before config if available {{{
  if filereadable(expand("~/.vimrc.before"))
    source ~/.vimrc.before
  endif
" }}}

" Use plugins config {{{
  if filereadable(expand("~/.vimrc.plugins"))
    source ~/.vimrc.plugins
  endif
" }}}

" General {{{

  set background=dark " Assume a dark background

  filetype plugin indent on " Automatically detect file types.
  syntax on " Syntax highlighting
  set mouse=a " Automatically enable mouse usage
  set mousehide " Hide the mouse cursor while typing
  scriptencoding utf-8

  " Enable modelines
  set modeline

  " Fix mouse in vim under tmux
  if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
  endif

  " System clipboard support
  if has('clipboard')
    if has('unnamedplus') " When possible use + register for copy-paste
      set clipboard=unnamed,unnamedplus
    else " On mac and Windows, use * register for copy-paste
      set clipboard=unnamed
    endif
  endif

  "set autowrite " Automatically write a file when leaving a modified buffer
  set shortmess+=filmnrxoOtT " Abbrev. of messages (avoids 'hit enter')
  set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
  set virtualedit=block " Allow virtual editing in Visual block mode
  set history=1000 " Store a ton of history (default is 20)
  set nospell " Spell checking off
  set hidden " Allow buffer switching without saving

  set iskeyword-=. " '.' is an end of word designator
  set iskeyword-=# " '#' is an end of word designator
  set iskeyword-=- " '-' is an end of word designator

  " Instead of reverting the cursor to the last position in the buffer, we
  " set it to the first line when editing a git commit message
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

  " spf13-vim: restore cursor to file position in previous editing session
  function! ResCur()
    if line("'\"") <= line("$")
      normal! g`"
      return 1
    endif
  endfunction
  augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
  augroup END


  if exists('autochdir')
    " Do not automatically changed the working directory
    set noautochdir
  endif

  " Setting up the directories {{{
    set noswapfile " disable swap files
    set nobackup " disable backups
    if has('persistent_undo')
      set undofile " Undo file
      set undolevels=1000 " Maximum number of changes that can be undone
      set undoreload=10000 " Maximum number lines to save for undo on a buffer reload
    endif

    " Add exclusions to mkview and loadview
    " eg: *.*, svn-commit.tmp
    "let g:skipview_files = [
    "      \ '\[example pattern\]'
    "      \ ]
  " }}}

" }}}

" VIM UI {{{

  " Colors {{{
    " FIXME: check for the theme
    colorscheme molokai

    " Color of the tabline
    hi TabLine      ctermfg=White  ctermbg=DarkGray  cterm=NONE
    hi TabLineFill  ctermfg=White  ctermbg=Black     cterm=NONE
    hi TabLineSel   ctermfg=White  ctermbg=DarkBlue  cterm=NONE

    " Color of matching braces
    hi MatchParen   ctermfg=Yellow ctermbg=Black     cterm=bold

    " Color of a selected block
    hi Visual       ctermbg=238
  " }}}

  " Font
  set guifont=Monospace\ 11

  set tabpagemax=15 " Only show 15 tabs
  set showmode " Display the current mode

  set cursorline " Highlight current line

  highlight clear SignColumn " SignColumn should match background
  highlight clear LineNr " Current line number row will have same background color in relative mode
  "highlight clear CursorLineNr " Remove highlight color from current line number

  if has('cmdline_info')
    set ruler " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd " Show partial commands in status line and
                " Selected characters/lines in visual mode
  endif

  if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\ " Filename
    set statusline+=%w%h%m%r " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y] " Filetype
    set statusline+=\ [%{getcwd()}] " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%% " Right aligned file nav info
  endif

  set backspace=indent,eol,start " Backspace for dummies
  set linespace=0 " No extra spaces between rows
  set number " Line numbers on
  set relativenumber " Relative line numbers on
  set showmatch " Show matching brackets/parenthesis
  set incsearch " Find as you type search
  set hlsearch " Highlight search terms
  set winminheight=0 " Windows can be 0 line high
  set ignorecase " Case insensitive search
  set smartcase " Case sensitive when uc present
  set wildmenu " Show list instead of just completing
  set wildmode=list:longest,full " Command <Tab> completion, list matches, then longest common part, then all.
  set whichwrap=b,s,h,l,<,>,[,] " Backspace and cursor keys wrap too
  set scrolljump=5 " Lines to scroll when cursor leaves screen
  set scrolloff=3 " Minimum lines to keep above and below cursor
  set list
  set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

  set linebreak
  set wrap

  " Disable colorcolumn (use vim-lengthmatters instead)
  set colorcolumn=

  " Folding
  set foldmethod=manual
  set foldenable
  set foldlevel=100

  " Optimization
  set lazyredraw

  " Syntax coloring lines that are too long really slows Vim down
  set synmaxcol=200

  " Enable/disable GUI features
  set guioptions+=a " autoselect
  set guioptions+=c " console dialogs
  set guioptions-=m " menu bar
  set guioptions-=T " toolbar
  set guioptions-=l " left-hand scrollbar
  set guioptions-=L
  set guioptions-=r " right-hand scrollbar
  set guioptions-=R
  set guioptions-=b " bottom scrollbar

  " Disable all blinking:
  set guicursor+=a:blinkon0

  " FIXME: useful?
  set switchbuf=usetab
" }}}

" Key (re)Mappings {{{
  let mapleader = ','
  let maplocalleader = '_'

  " Wrapped lines goes down/up to next row, rather than next line in file.
  noremap j gj
  noremap k gk

  " Yank from the cursor to the end of the line, to be consistent with C and D.
  nnoremap Y y$

  " Code folding options
  nmap <leader>f0 :set foldlevel=0<CR>
  nmap <leader>f1 :set foldlevel=1<CR>
  nmap <leader>f2 :set foldlevel=2<CR>
  nmap <leader>f3 :set foldlevel=3<CR>
  nmap <leader>f4 :set foldlevel=4<CR>
  nmap <leader>f5 :set foldlevel=5<CR>
  nmap <leader>f6 :set foldlevel=6<CR>
  nmap <leader>f7 :set foldlevel=7<CR>
  nmap <leader>f8 :set foldlevel=8<CR>
  nmap <leader>f9 :set foldlevel=9<CR>

  " To clear search highlighting rather than toggle it on and off
  nmap <silent> <leader>/ :nohlsearch<CR>

  " Find merge conflict markers
  map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

  " Shortcuts
  " Change Working Directory to that of the current file
  cmap cwd lcd %:p:h
  cmap cd. lcd %:p:h

  " Visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv

  " Allow using the repeat operator with a visual selection (!)
  " http://stackoverflow.com/a/8064607/127816
  vnoremap . :normal .<CR>

  " Force saving files that require root permission with w!!
  cmap w!! w !sudo tee % >/dev/null

  " Map <Leader>ff to display all lines with keyword under cursor
  " and ask which one to jump to
  nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

  " Easier horizontal scrolling
  map zl zL
  map zh zH

  " Easier formatting
  nnoremap <silent> <leader>q gwip
" }}}

" Plugins {{{

  " Airline {{{
    " Font (patched for airline)
    let g:airline_powerline_fonts = 1
    let g:airline_theme="murmur"
  " }}}

  " Ctags {{{
    " Note: with Git hooks available in these dotfiles, using "git ctags" will
    " generate tags in .git/tags
    set tags=./.git/tags;$HOME/.vim/tags/*.tags

    " Make tags placed in .git/tags file available in all levels of a repository
    let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
    if gitroot != ''
      let &tags = &tags . ',' . gitroot . '/.git/tags'
    endif
  " }}}

  " ctrlp.vim {{{
    " Stay in the root directory of the project
    let g:ctrlp_working_path_mode = 'r'

    " Disable case sensitivity
    let g:ctrlp_mruf_case_sensitive = 0

    " Ignore build directories
    let g:ctrlp_user_command = {
          \ 'types': {
          \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others | grep -v "build"'],
          \ 2: ['.hg', 'hg --cwd %s locate -I . | grep -v "build"'],
          \ },
          \ 'fallback': 'find %s -type f'
          \ }
  " }}}

  " DoxygenToolkit.vim {{{
    if isdirectory(expand("~/.vim/plugged/DoxygenToolkit.vim"))
      " Use C++ here for /// doxygen doc, else /** */ is used.
      let g:DoxygenToolkit_commentType = "C++"
      " Leading character used for @brief, @param...
      let g:DoxygenToolkit_versionString = "\\"
      " Comment block with ,d
      nmap <Leader>d :Dox<Enter>

      let g:DoxygenToolkit_briefTag_pre="\\brief "
      let g:DoxygenToolkit_paramTag_pre="\\param "
      let g:DoxygenToolkit_templateParamTag_pre="\\tparam "
      let g:DoxygenToolkit_throwTag_pre="\\throw "
      let g:DoxygenToolkit_returnTag="\\return "
      let g:DoxygenToolkit_blockHeader=""
      let g:DoxygenToolkit_blockFooter=""
      let g:DoxygenToolkit_authorName=$FULLNAME
      "let g:DoxygenToolkit_licenseTag=
    endif
  " }}}

  " EasyAlign {{{
    if isdirectory(expand("~/.vim/plugged/vim-easy-align"))
      " Start interactive EasyAlign in visual mode
      vmap <Enter> <Plug>(EasyAlign)

      " Start interactive EasyAlign with a Vim movement
      nmap <Leader>a <Plug>(EasyAlign)

      let g:easy_align_delimiters = {
      \ ' ': { 'pattern': ' ', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
      \ '=': { 'pattern': '===\|<=>\|\(&&\|||\|<<\|>>\)=\|=\~[#?]\?\|=>\|[:+/*!%^=><&|.-]\?=[#?]\?',
      \ 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ ':': { 'pattern': ':', 'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
      \ ',': { 'pattern': ',', 'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
      \ '|': { 'pattern': '|', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ '.': { 'pattern': '\.', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
      \ '&': { 'pattern': '\\\@<!&\|\\\\', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ '{': { 'pattern': '(\@<!{', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ '}': { 'pattern': '}', 'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 },
      \ '\': { 'pattern': '\\', 'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 },
      \ '<': { 'pattern': '<', 'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 },
      \ 'd': { 'pattern': ' \(\S\+\s*[;=]\)\@=', 'left_margin': 0, 'right_margin': 0},
      \ '#': { 'pattern': '#', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 }
      \ }
    endif
  " }}}

  " EasyMotion {{{
    if isdirectory(expand("~/.vim/plugged/vim-easymotion"))
      " Disable default mappings
      let g:EasyMotion_do_mapping = 0

      let g:EasyMotion_smartcase = 1

      nmap <Leader>w <Plug>(easymotion-bd-w)
      nmap <Leader>s <Plug>(easymotion-s2)
    endif
  " }}}

  " NerdTree {{{
    if isdirectory(expand("~/.vim/plugged/nerdtree"))
      map  <C-e>      <plug>NERDTreeTabsToggle<CR>
      map  <leader>e  :NERDTreeFind<CR>
      nmap <leader>nt :NERDTreeFind<CR>
      let NERDTreeShowBookmarks=1
      let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
      let NERDTreeChDirMode=0
      let NERDTreeQuitOnOpen=1
      let NERDTreeMouseMode=2
      let NERDTreeShowHidden=1
      let NERDTreeKeepTreeInNewTab=1
      let g:nerdtree_tabs_open_on_gui_startup=0
    endif
  " }}}

  " Startify {{{
    " Call fortune and cowsay (if present)
    let g:startify_custom_header =
      \ map(split(system('cowsay -f "$(ls /usr/share/cows/ | sort -R | head -1)" "$(fortune -s)"'), '\n'), '" ". v:val') + ['','']

    " Skip list
    let g:startify_skiplist = [
      \ '^/tmp'
      \ ]

    " Number of files
    let g:startify_files_number = 5
  " }}}

  " UltiSnips {{{
    " Trigger configuration.
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

    " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="vertical"

    " Custom snippets
    let g:UltiSnipsSnippetsDir = "~/.vim/plugged/vim-snippets/custom_snippets"
    let g:UltiSnipsSnippetDirectories=["UltiSnips", "custom_snippets"]

    " Prevent UltiSnips from stealing ctrl-k.
    augroup VimStartup
      autocmd!
      autocmd VimEnter * sil! iunmap <c-k>
    augroup end

    " Use ctrl-b instead.
    let g:UltiSnipsJumpBackwardTrigger = "<c-b>"
  " }}}

  " Vim-CtrlSpace {{{
    let g:airline_exclude_preview = 1
    let g:ctrlspace_use_tabline = 1
    let g:ctrlspace_use_mouse_and_arrows_in_term = 1
    hi CtrlSpaceSelected term=reverse ctermfg=187  ctermbg=23   cterm=bold
    hi CtrlSpaceNormal   term=NONE    ctermfg=244  ctermbg=232  cterm=NONE
    hi CtrlSpaceFound                 ctermfg=220  ctermbg=NONE cterm=bold
  " }}}

" }}}

" Optimization
set viminfo=<0,'0,/150,:100,h,f0,s0

" Remove indent guides
let g:indent_guides_enable_on_vim_startup = 0

" Set hidden character list that can de display with set list
set listchars=tab:>-,trail:~,extends:>,precedes:<


" Navigation for tabs
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabprev<CR>
nnoremap tk  :tabnext<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tm  :tabm<Space>
nnoremap tn  :tabnew<CR>
nnoremap td  :tabclose<CR>

" Fix spellchecking color
hi clear SpellBad
hi SpellBad cterm=underline ctermfg=red

"====[ Automatically reload .vimrc when updated ]====
" See: http://superuser.com/questions/132029/how-do-you-reload-your-vimrc-file-without-restarting-vim
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

"====[ Add CUDA support ]====
au BufNewFile,BufRead *.cu,*.cuh set ft=cu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Damian Conway's OSCON 2013 tricks
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"====[ Highlight the match in red ]====
" This rewires n and N to do the highlighing
nnoremap <silent> n   n:call HLNext(0.1)<cr>
nnoremap <silent> N   N:call HLNext(0.1)<cr>

function! HLNext (blinktime)
    highlight WhiteOnRed ctermfg=white ctermbg=red
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#'.@/
    let ring = matchadd('WhiteOnRed', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction


"====[ Make CTRL-K list diagraphs before each digraph entry ]====
"inoremap <expr>  <C-K>   HUDG_GetDigraph()
"inoremap <expr>  <C-K>   BDG_GetDigraph()
"inoremap <expr>  <C-Z>   HUDG_GetDigraph()

"====[ Move/duplicate blocks of code ]====
vmap  <expr>  D        DVB_Duplicate()
vmap  <expr>  h        DVB_Drag('left')
vmap  <expr>  l        DVB_Drag('right')
vmap  <expr>  j        DVB_Drag('down')
vmap  <expr>  k        DVB_Drag('up')

" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Miscellaneous development
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Doxygen syntax highlighting
let g:load_doxygen_syntax=1

" Default number of spaces for indent
set shiftwidth=2

" N-s: do not indent C++ namespaces
" g0:  do not indent public,private...
" (0:  align function arguments
set cino=N0,g0,(0

" Default Vim completion should not look for all include files (slow)
set complete-=i

" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Move quickfix window to bottom
autocmd FileType qf wincmd J

" Add comment on newline when dealing with doxygen comments
au FileType c,cpp,cuda setlocal formatoptions+=r
au FileType c,cpp,cuda setlocal formatoptions+=c
au FileType c,cpp,cuda setlocal formatoptions+=o
au FileType c,cpp,cuda setlocal comments-=://
au FileType c,cpp,cuda setlocal comments+=:///

" Python-mode can be quite slow
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_lookup_project = 0

" Do not indent template in C++
function! CppNoTemplateIndent()
  let l:cline_num = line('.')
  let l:cline = getline(l:cline_num)
  let l:pline_num = prevnonblank(l:cline_num - 1)
  let l:pline = getline(l:pline_num)
  while l:pline =~# '\(^\s*{\s*\|^\s*//\|^\s*/\*\|\*/\s*$\)'
    let l:pline_num = prevnonblank(l:pline_num - 1)
    let l:pline = getline(l:pline_num)
  endwhile
  let l:retv = cindent('.')
  let l:pindent = indent(l:pline_num)
  "template<typename U,
  "<--- here
  if l:pline =~# '^\s*template\s*[<]\=\s*[0-9a-zA-Z_ ,\t]*$'
    let l:retv = l:pindent + &shiftwidth
  "template <typename U, typename V>
  "<--- here
  elseif l:pline =~# '^\s*template\s*<[0-9a-zA-Z_ ,\t]*>\s*$'
    let l:retv = l:pindent
  " Foo<Bar>
  "<--- here
  elseif l:pline =~# '^\s*[0-9a-zA-Z_]*\s*<[0-9a-zA-Z_ ,\t]*>\s*$'
    let l:retv = l:pindent + &shiftwidth
  elseif l:pline =~# '^\s*typename\s*.*,\s*$'
    let l:retv = l:pindent
  " Foo<Bar<int,double> >
  "<--- here
  elseif l:pline =~# '^\s*[0-9a-zA-Z ,\t:]*\s*<\s*[0-9a-zA-Z ,\t:&]*\s*<\s*[0-9a-zA-Z ,\t:&]*\s*>\s*>\s*[0-9a-zA-Z ,\t:&]*\s*$'
    let l:retv = l:pindent + &shiftwidth
  "  typename U>
  "<--- here
  elseif l:pline =~# '^\s*[0-9a-zA-Z ,\t]*\s*>\s*$'
    let l:retv = l:pindent - &shiftwidth
  elseif l:cline =~# '^[0-9a-zA-Z_ ,\t]*>\s*$'
    let l:retv = l:pindent - &shiftwidth
  "elseif l:pline =~# '^\s*namespace.*'
  "  let l:retv = 0
  endif
  return l:retv
endfunction

if has("autocmd")
  autocmd BufEnter *.{cc,cxx,cpp,cu,h,hh,hpp,hxx,cuh} setlocal indentexpr=CppNoTemplateIndent()
endif

" Write file, call emacs for indenting, then reload
" To use this:
" :call EmacsIndent()
function! EmacsIndent()
  let l:filename = expand("%:p")
  w
  echom system("emacs -batch " . l:filename . " --eval '(indent-region (point-min) (point-max) nil)' -f save-buffer -kill")
  edit!
  redraw
endfunction

" See: http://stackoverflow.com/a/6171215/1043187
" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
  let string=a:string
" Escape regex characters
  let string = escape(string, '^$.*\/~[]')
" Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - http://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
" Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&

" Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')

" Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save

"Escape any special characters in the selection
  let escaped_selection = EscapeString(selection)

  return escaped_selection
endfunction

" Start the find and replace command from the cursor position to the end of
" the file
vmap <leader>z <Esc>:,$s/<c-r>=GetVisual()<cr>/
" Start the find and replace command across the whole file
vmap <leader>zz <Esc>:%s/<c-r>=GetVisual()<cr>/

" If doing a diff. Upon writing changes to file, automatically update the
" differences
autocmd BufWritePost * if &diff == 1 | diffupdate | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" cmake.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:cmake_cxx_compiler = 'g++'
let g:cmake_c_compiler = 'gcc'
let g:cmake_build_dirs = [ "build" ]
let g:cmake_build_type = "RelWithDebInfo"
let g:cmake_inject_flags = {}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" ListToggle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lt_location_list_toggle_map = '<leader>ll'
let g:lt_quickfix_list_toggle_map = '<leader>ql'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Neocomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable AutoComplPop.
"let g:acp_enableAtStartup = 0

" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" numbers.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable
let g:enable_numbers = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight link SyntasticError ErrMsg
highlight link SyntasticWarning airline_warning
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" vim-clang-format
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" llvm, google, chromium, mozilla
let g:clang_format#code_style='llvm'

let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -2,
            \ "AlignTrailingComments" : "false",
            \ "AllowShortFunctionsOnASingleLine" : "false",
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "CommentPragmas" : "",
            \ "PointerAlignment" : "Left",
            \ "SpaceBeforeParens" : "Always",
            \ "SpacesBeforeTrailingComments" : 1,
            \ "Standard" : "C++03",
            \ "NamespaceIndentation" : "All",
            \ "BreakBeforeBraces" : "Allman"}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" vim-multiple-cursors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Redefine mapping
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_key='<C-n>'
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" vim-signify
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:signify_vcs_list = [ 'git' ]
let g:signify_disable_by_default = 0
let g:signify_update_on_bufenter = 0
let g:signify_line_highlight = 0
let g:signify_update_on_focusgained = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" YankStack
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set <M-p>=^[p
set <M-P>=^[P

" fix meta-keys which generate <Esc>a .. <Esc>z
let c='a'
while c <= 'z'
  exec "set <M-".toupper(c).">=\e".c
  exec "imap \e".c." <M-".toupper(c).">"
  let c = nr2char(1+char2nr(c))
endw

" Work around the ambiguity with escape sequences
set ttimeout ttimeoutlen=50

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" YouCompleteMe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Change the default key-binding of YCM to <C-TAB> and <C-S-TAB>
" to make it compatible with UltiSnips
let g:ycm_key_list_select_completion=['<C-TAB>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-S-TAB>', '<Up>']

let g:ycm_key_detailed_diagnostics = '<leader>c'

" See: http://0x3f.org/blog/make-youcompleteme-ultisnips-compatible/
" Set the default action of SuperTab to triggering <C-TAB>
"let g:SuperTabDefaultCompletionType = '<C-Tab>'
let g:SuperTabBackward = '<C-S-Tab>'

let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" Use tags that can be generated with 'git ctags'
let g:ycm_collect_identifiers_from_tags_files = 1

" Enable/disable diagnostics UI
let g:ycm_show_diagnostics_ui = 1
let g:ycm_enable_diagnostic_highlighting = 1
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_add_preview_to_completeopt = 0
set completeopt=menu

set splitbelow
set splitright
set winfixheight

let g:ycm_always_populate_location_list = 1

let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_max_diagnostics_to_display = 4
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_cache_omnifunc = 1

" Turn YCM off?
let g:ycm_auto_trigger = 1

nmap <Leader>n :lnext<Enter>
nmap <Leader>p :lprevious<Enter>

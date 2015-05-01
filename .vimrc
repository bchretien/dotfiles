" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker spell: ft=vim
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

  " Splitting style
  set splitbelow
  set splitright

  " Keep the window height when windows are opened or closed
  set winfixheight

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

  set title titlestring=Vim:\ %F

  " Setting up the directories {{{
  set noswapfile " disable swap files
  set nobackup " disable backups
  if has('persistent_undo')
    set undolevels=1000 " Maximum number of changes that can be undone
    set undoreload=10000 " Maximum number lines to save for undo on a buffer reload
    set undodir=~/.vimundo/
    set undofile " Undo file
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
    " Enable 256 colors
    if $TERM == "xterm-256color"
      set t_Co=256
    endif

    " Change cursor color
    if &term =~ "xterm\\|rxvt\\|screen"
      " cursor color in insert mode
      let &t_SI = "\<Esc>]12;#118A3D\x7"
      " else
      let &t_EI = "\<Esc>]12;#115E8B\x7"
      silent !echo -ne "\033]12;blue\007"
      " reset cursor when vim exits
      autocmd VimLeave * silent !echo -ne "\033]112\007"
      " use \003]12;gray\007 for gnome-terminal
    endif

    " FIXME: check for the theme
    " Schemes: hybrid, jellybeans, lizard256, lucius, LuciusDarkLowContrast, molokai, smyck
    colorscheme hybrid

    " Fix cursor in search for hybrid
    hi Cursor ctermfg=16 ctermbg=253

    " Fix spellchecking color
    hi clear SpellBad
    hi SpellBad cterm=underline ctermfg=red

    highlight clear SignColumn " SignColumn should match background
    highlight clear LineNr " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr " Remove highlight color from current line number

    au BufRead,BufWinEnter * if &diff || (v:progname =~ "diff") | set nocursorline | endif
  " }}}

  " Font
  set guifont=Monospace\ 11

  set tabpagemax=15 " Only show 15 tabs
  set showmode " Display the current mode

  set cursorline " Highlight current line

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

  set completeopt+=menuone
  set completeopt-=preview

  " Default Vim completion should not look for all include files (slow)
  set complete-=i
  " Default Vim completion should not look for all tags (slow)
  set complete-=t

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
  let maplocalleader = ';'

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
  vnoremap <silent> <leader>q gw

  " Navigate the location list
  nmap <Leader>n :lnext<Enter>
  nmap <Leader>p :lprevious<Enter>

  " Exit insert mode with Ctrl+C without skipping InsertLeave event
  inoremap <C-c> <Esc>

  " Use jk as an <Esc> replacement
  imap jk <Esc>

  " Navigation
  nnoremap j gj
  nnoremap k gk
  xnoremap j gj
  xnoremap k gk

  " Navigation for tabs
  nnoremap th  :tabfirst<CR>
  nnoremap tj  :tabprev<CR>
  nnoremap tk  :tabnext<CR>
  nnoremap tl  :tablast<CR>
  nnoremap tm  :tabm<Space>
  nnoremap tn  :tabnew<CR>
  nnoremap td  :tabclose<CR>

  nnoremap tt  :tabnext<CR>

  nnoremap <Leader>k :cnext<CR>
  nnoremap <Leader>j :cprev<CR>

  "This unsets the "last search pattern" register by hitting return
  nnoremap <CR> :noh<CR><CR>

  " When the popup menu is opened, make the Enter key select the completion
  " entry instead of creating a new line
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " qq to record, Q to replay (plus disable Ex mode)
  nmap Q @q

  " <tab> / <s-tab> | Circular windows navigation
  nnoremap <tab>   <c-w>w
  nnoremap <S-tab> <c-w>W

  " Start the find and replace command from the cursor position to the end of
  " the file
  vmap <leader>z <Esc>:,$s/<c-r>=GetVisual()<cr>/
  " Start the find and replace command across the whole file
  vmap <leader>zz <Esc>:%s/<c-r>=GetVisual()<cr>/

  " Select pasted text
  nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

  " Sort space-separated words on a line
  vnoremap <F2> d:execute 'normal i' . join(sort(split(getreg('"'))), ' ')<CR>

  " Resize splits when the window is resized
  au VimResized * :wincmd =
" }}}

" Plugins {{{

  " Airline {{{
    " Font (patched for airline)
    let g:airline_powerline_fonts = 1
    let g:airline_theme="murmur"

    let g:airline#extensions#whitespace#enabled = 0

    let g:airline_section_c = '%F'
  " }}}

  " clang_complete {{{
    " Use the library rather than the executable
    let g:clang_use_library=1
    let g:clang_library_path = "/usr/lib"

    " Limit memory use
    let g:clang_memory_percent=70

    let g:clang_make_default_keymappings = 0

    " Snippets
    let g:clang_snippets = 1
    let g:clang_snippets_engine = 'ultisnips'
    let g:clang_conceal_snippets = 1

    let g:clang_periodic_quickfix = 0
    let g:clang_hl_errors = 0

    let g:clang_close_preview = 1
    let g:clang_complete_auto = 0
    let g:clang_auto_select = 0
    let g:clang_complete_copen = 1

    augroup myvimrc
        au!
        au BufRead,BufNewFile *.cc,*.cpp,*.cxx,*.cu,*.hh,*.hxx,*.hpp,*.cuh 
          \ if &omnifunc != "ClangComplete" |
          \ echo "WARNING: omnifunc is not net to ClangComplete!" |
          \ endif
    augroup END
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
          \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
          \ 2: ['.hg', 'hg --cwd %s locate -I .'],
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
      \ '#': { 'pattern': '#', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ '[': { 'pattern': '(\@<![', 'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
      \ ']': { 'pattern': ']', 'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 },
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

  " github-issues.vim {{{
    " github-issues will use upstream issues (if repo is fork)
    let g:github_upstream_issues = 1

    " omnicomplete will not be populated until it is triggered
    let g:gissues_lazy_load = 1
  " }}}

  " haskellmode-vim {{{
    let g:haddock_browser="$BROWSER"
  " }}}

  " incsearch {{{
    let g:incsearch#auto_nohlsearch = 1

    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
  " }}}

  " jedi.vim {{{
    let g:pymode_rope = 0
    let g:jedi#popup_on_dot = 1
    let g:jedi#popup_select_first = 0
    let g:jedi#auto_initialization = 1
    let g:jedi#show_call_signatures = 1
    let g:jedi#rename_command = "<leader>R"
    let g:jedi#use_tabs_not_buffers = 0

    " Neocomplete-related fixes
    autocmd FileType python setlocal omnifunc=jedi#completions
    let g:jedi#completions_enabled = 0
    let g:jedi#auto_vim_configuration = 0
  " }}}

  " lightline.vim {{{
    if isdirectory(expand("~/.vim/plugged/lightline.vim"))
      let g:lightline = {
            \ 'colorscheme': 'murmur',
            \ 'enable': {
            \   'tabline': 1,
            \   'statusline': 1,
            \ },
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ],
            \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \ 'component': {
            \   'readonly': '%{&filetype=="help"?"":&readonly?"":""}',
            \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
            \   'fugitive': '%{exists("*fugitive#head")? " ".fugitive#head():""}'
            \ },
            \ 'component_visible_condition': {
            \   'readonly': '(&filetype!="help"&& &readonly)',
            \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
            \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
            \ },
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' }
            \ }

      let g:lightline.tabline = {
            \ 'left': [ [ 'tabs' ] ],
            \ 'right': [ [ 'close' ] ] }

      "let g:lightline.component_expand = {
            "\ 'tabs': 'ctrlspace#tabline' }

      "let g:lightline.component_type = {
            "\ 'tabs': 'raw' }
    endif
  " }}}

  " neco-ghc {{{
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
    let g:necoghc_enable_detailed_browse = 1
    let g:necoghc_debug = 1
  " }}}

  " neocomplete {{{
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " AutoComplPop like behavior.
    let g:neocomplete#enable_auto_select = 0
    let g:neocomplete#enable_refresh_always = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#auto_completion_start_length = 3

    let g:neocomplete#enable_prefetch = 1
    let g:neocomplete#skip_auto_completion_time = "0.1"

    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    let g:neocomplete#use_vimproc = 1

    " Fix neco-ghc errors
    let g:neocomplete#force_overwrite_completefunc = 1

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
          \ 'default' : ''
          \ }

    let g:neocomplete#enable_omni_fallback = 0

    if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:neocomplete#force_omni_input_patterns.c =
          \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
    let g:neocomplete#force_omni_input_patterns.cpp =
          \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

    " Jedi support
    let g:neocomplete#force_omni_input_patterns.python =
          \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
  " }}}

  " python-mode {{{
    " Use QuickRun for that
    let g:pymode_run = 1

    " Python-mode can be quite slow
    let g:pymode_rope_complete_on_dot = 0
    let g:pymode_rope_lookup_project = 0
  " }}}

  " QuickRun {{{
    if isdirectory(expand("~/.vim/plugged/vim-quickrun"))
      noremap  <leader>r :QuickRun -runner vimproc -buffer/running_mark "Running..."<CR>
      vnoremap <leader>r :QuickRun -runner vimproc -buffer/running_mark "Running..."<CR>
    endif
  " }}}

  " Startify {{{
    " Call fortune and cowsay (if present)
    let g:startify_custom_header =
      \ map(split(system('cowsay -f "$(ls /usr/share/cows/ | grep -vE "sod|kiss|surg|tele" | sort -R | head -1)" "$(fortune -s)"'), '\n'), '" ". v:val') + ['','']

    " Skip list
    let g:startify_skiplist = [
      \ '^/tmp'
      \ ]

    " Number of files
    let g:startify_files_number = 5
  " }}}

  " SuperTab {{{
    let g:SuperTabDefaultCompletionType = '<Tab>'
    let g:SuperTabBackward = '<C-S-Tab>'
  " }}}

  " Syntastic {{{
    highlight link SyntasticError   ErrMsg
    highlight link SyntasticWarning airline_warning
    let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
  " }}}

  " UltiSnips {{{
    " Trigger configuration.
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
    let g:UltiSnipsListSnippets="<c-tab>"

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
    "let g:UltiSnipsJumpBackwardTrigger = "<c-b>"
  " }}}

  " Unite {{{
    " General options
    let g:unite_enable_start_insert = 1
    let g:unite_data_directory = expand("~/.vim/unite")
    let g:unite_source_history_yank_enable = 1

    call unite#custom#profile('default', 'context', {
          \ 'winheight': 10,
          \ 'direction': 'botright',
          \ 'prompt': '» ',
          \ })

    " Ignore build directories
    call unite#custom#source('file_rec,file_rec/async', 'ignore_pattern', '\/build')
    call unite#custom#source('grep', 'ignore_pattern', '\/build')

    " File
    let g:unite_source_file_ignore_pattern =
          \'tmp\|^\%(/\|\a\+:/\)$\|\~$\|\.\%(o|exe|dll|bak|sw[po]\)$'

    " Search
    let g:unite_source_grep_max_candidates = 1000
    let g:unite_source_find_max_candidates = 1000

    " silver_searcher
    if executable('ag')
      let g:unite_source_grep_command = 'ag'
      let g:unite_source_grep_default_opts = '-f --line-numbers --nocolor --nogroup -i ' .
            \ '--hidden --ignore ".hg" --ignore ".svn" --ignore ".git" ' .
            \ '--ignore "bzr" --ignore ".svg"  '
      let g:unite_source_grep_recursive_opt = ''
    endif

    " Mappings {{{
      nnoremap [unite] <Nop>
      nmap ' <SID>[unite]

      nnoremap <SID>[unite]u :<C-u>Unite
      nnoremap <SID>[unite]' :<C-u>Unite buffer file<CR>
      nnoremap <SID>[unite]b :<C-u>Unite buffer<CR>
      nnoremap <SID>[unite]f :<C-u>Unite file<CR>
      "nnoremap <SID>[unite]H :<C-u>Unite help<CR>
      "nnoremap <SID>[unite]t :<C-u>Unite tag<CR>
      "nnoremap <SID>[unite]T :<C-u>Unite -immediately -no-start-insert tag:<C-r>=expand('<cword>')<CR><CR>
      nnoremap <SID>[unite]w :<C-u>Unite tab<CR>
      "nnoremap <SID>[unite]m :<C-u>Unite file_mru<CR>
      nnoremap <SID>[unite]o :<C-u>Unite outline<CR>
      nnoremap <SID>[unite]q :<C-u>Unite qf -no-quit<CR>
      "nnoremap <SID>[unite]M :<C-u>Unite mark<CR>
      nnoremap <SID>[unite]r :<C-u>Unite register<CR>
      nnoremap <SID>[unite]g :<C-u>Unite grep -no-quit -direction=botright -buffer-name=grep-buffer<CR>

      " Grep-like search
      nnoremap <Leader>/  :Unite grep -no-quit<CR><CR>
      nnoremap <Leader>// :Unite grep -no-quit<CR>
      vnoremap <Leader>/  y:Unite grep -no-quit<CR><CR><C-R>=escape(@", '\\.*$^[]')<CR><CR>

      " File search, CtrlP style
      nnoremap <C-p> :<C-u>Unite -buffer-name=files -start-insert -default-action=open file_rec/async:!<CR>
      nnoremap <C-p>p :<C-u>Unite -buffer-name=files -start-insert -default-action=open file_rec/async:
    " }}}

    " Plugins {{{
      nnoremap <SID>[unite]c :<C-u>Unite -no-quit colorscheme<CR>

      " vimfiler
      let g:vimfiler_as_default_explorer = 1
      let g:vimfiler_safe_mode_by_default = 0
      let g:vimfiler_split_action = "split"
      let g:vimfiler_split_rule = "topleft"
      nmap <leader>e :VimFilerExplorer -project -split -invisible -no-quit<CR>
    " }}}
  " }}}

  " Vim-CtrlSpace {{{
    let g:airline_exclude_preview = 1
    let g:ctrlspace_use_tabline = 1
    let g:ctrlspace_use_mouse_and_arrows_in_term = 1
    hi CtrlSpaceSelected term=reverse ctermfg=187  ctermbg=23   cterm=bold
    hi CtrlSpaceNormal   term=NONE    ctermfg=244  ctermbg=232  cterm=NONE
    hi CtrlSpaceFound                 ctermfg=220  ctermbg=NONE cterm=bold
  " }}}

  " vim-latex {{{
    let g:latex_build_dir = './build'
  " }}}

  " vim-lengthmatters {{{
  let g:lengthmatters_excluded = ['unite', 
        \ 'tagbar', 'startify', 'gundo', 
        \ 'vimshell', 'w3m', 'nerdtree',
        \ 'help', 'qf', 'gfimarkdown', 'log']

  " }}}

  " vim-marching {{{
    if isdirectory(expand("~/.vim/plugged/vim-marching"))
      let g:marching_enable_neocomplete = 1
      let g:marching_enable_auto_select = 1
      let g:marching_backend = "clang_command"
      "let g:marching_clang_command_option="-std=c++11"
      let g:marching_wait_time = 0.5
      let g:marching_enable_refresh_always = 0

      set updatetime=200

      " Load include paths:
      "  - Standard library
      "  - Boost
      "  - Eigen 3
      let g:marching_include_paths = filter(
            \ split(glob('/usr/include/c++/*'), '\n') +
            \ split(glob('/usr/include/c++/*/*/bits'), '\n') +
            \ split(glob('/usr/include/boost/*'), '\n') +
            \ split(glob('/usr/include/eigen3'), '\n'),
            \ 'isdirectory(v:val)')

      "imap <buffer> <C-x><C-o> <Plug>(marching_start_omni_complete)
      "imap <buffer> <C-x><C-x><C-o> <Plug>(marching_force_start_omni_complete)
    endif
  " }}}

  " vim-multiple-cursors {{{
    " Redefine mapping
    let g:multi_cursor_use_default_mapping=0
    let g:multi_cursor_start_key='<C-n>'
    let g:multi_cursor_next_key='<C-n>'
    let g:multi_cursor_prev_key='<C-p>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<Esc>'

    if isdirectory(expand("~/.vim/plugged/neocomplete.vim"))
      " Called once right before you start selecting multiple cursors
      function! Multiple_cursors_before()
        if exists(':NeoCompleteLock')==2
          exe 'NeoCompleteLock'
        endif
      endfunction

      " Called once only when the multiple selection is canceled (default <Esc>)
      function! Multiple_cursors_after()
        if exists(':NeoCompleteUnlock')==2
          exe 'NeoCompleteUnlock'
        endif
      endfunction
    endif
  " }}}


  " vim-snowdrop {{{
    let g:snowdrop#libclang_path = "/usr/lib"
    let g:snowdrop#libclang_file = "libclang.so"
    "let g:snowdrop#include_paths = {
          "\ "cpp" : [
          "\ "/usr/include",
          "\ "/usr/include/boost",
          "\ "/usr/include/eigen3"
          "\ ]}
  " }}}

  " tagbar {{{
    nmap <Leader>t :TagbarToggle<CR>
  " }}}

" }}}

" Toolbox {{{
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

  " Write mapped keys to a new buffer
  function! Map()
    redir @a
    silent map
    silent map!
    redir END
    new
    put! a
  endfunction

  " Zoom / Restore window.
  function! s:ZoomToggle() abort
      if exists('t:zoomed') && t:zoomed
          execute t:zoom_winrestcmd
          let t:zoomed = 0
      else
          let t:zoom_winrestcmd = winrestcmd()
          resize
          vertical resize
          let t:zoomed = 1
      endif
  endfunction
  command! ZoomToggle call s:ZoomToggle()
  nnoremap <silent> <Leader><Leader> :ZoomToggle<CR>
" }}}

" Filetypes {{{
  " PKGBUILD support
  au BufRead,BufNewFile PKGBUILD  set filetype=sh

  " Automatically reload .vimrc when updated
  " See: http://superuser.com/questions/132029/how-do-you-reload-your-vimrc-file-without-restarting-vim
  augroup myvimrc
      au!
      au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
  augroup END

  " CUDA support
  au BufNewFile,BufRead *.cu,*.cuh set ft=cpp
" }}}

" Optimization
set viminfo=<0,'0,/150,:100,h,f0,s0

" Remove indent guides
let g:indent_guides_enable_on_vim_startup = 0

" Set hidden character list that can de display with set list
set listchars=tab:>-,trail:~,extends:>,precedes:<

" Protect large files from sourcing and other overhead.
" Files become read only
if !exists("my_auto_commands_loaded")
  let my_auto_commands_loaded = 1
  " Large files are > 10M
  " Set options:
  " eventignore+=FileType (no syntax highlighting etc
  " assumes FileType always on)
  " noswapfile (save copy of file)
  " bufhidden=unload (save memory when other file is viewed)
  " buftype=nowritefile (is read-only)
  " undolevels=-1 (no undo possible)
  let g:LargeFile = 1024 * 1024 * 10
  augroup LargeFile
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
  augroup END
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Damian Conway's OSCON 2013 tricks
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"====[ Highlight the match in red ]====
" This rewires n and N to do the highlighing
"nnoremap <silent> n   n:call HLNext(0.1)<cr>
"nnoremap <silent> N   N:call HLNext(0.1)<cr>

"function! HLNext (blinktime)
    "highlight WhiteOnRed ctermfg=white ctermbg=red
    "let [bufnum, lnum, col, off] = getpos('.')
    "let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    "let target_pat = '\c\%#'.@/
    "let ring = matchadd('WhiteOnRed', target_pat, 101)
    "redraw
    "exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    "call matchdelete(ring)
    "redraw
"endfunction


"====[ Make CTRL-K list diagraphs before each digraph entry ]====
"inoremap <expr>  <C-K>   HUDG_GetDigraph()
"inoremap <expr>  <C-K>   BDG_GetDigraph()
"inoremap <expr>  <C-Z>   HUDG_GetDigraph()

"====[ Move/duplicate blocks of code ]====
vmap  <expr>  h        DVB_Drag('left')
vmap  <expr>  l        DVB_Drag('right')
vmap  <expr>  j        DVB_Drag('down')
vmap  <expr>  k        DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Miscellaneous development
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Doxygen syntax highlighting
let g:load_doxygen_syntax=1

" Default number of spaces for indent
set shiftwidth=2
set expandtab
set tabstop=2

" N-s: do not indent C++ namespaces
" g0:  do not indent public,private...
" (0:  align function arguments
set cino=N0,g0,(0

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
"" numbers.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable
let g:enable_numbers = 0

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

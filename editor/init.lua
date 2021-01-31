-- See: https://oroques.dev/notes/neovim-init/
-- Or: https://github.com/sum-catnip/nvim

-------------------- HELPERS -------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

-- Taken from: https://stackoverflow.com/a/23535333/1043187
local function script_path()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end
local nvim_dir = script_path()

local plugins_dir = os.getenv("HOME") .. '/.local/share/nvim/site/pack/paqs/start/'

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Check if a file or directory exists in this path
-- See: https://stackoverflow.com/a/40195356/1043187
local function exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

-- Check if a directory exists in this path
-- See: https://stackoverflow.com/a/40195356/1043187
local function isdir(path)
  -- "/" works on both Unix and Windows
  return exists(path.."/")
end

-------------------- PLUGINS -------------------------------
cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself

-- Edition plugins
paq {'mg979/vim-visual-multi'}
paq {'tpope/vim-surround'}
paq {'justinmk/vim-sneak'}
paq {'junegunn/vim-easy-align'} -- TODO: lazy loading
paq {'sirver/ultisnips'} -- UltiSnips engine
paq {'honza/vim-snippets'} -- Snippets
paq {'jiangmiao/auto-pairs'} -- Auto-close feature for parentheses, brackets etc.
paq {'nvim-treesitter/nvim-treesitter'}

-- Development plugins
paq {'vim-scripts/DoxygenToolkit.vim'} -- TODO: lazy loading
paq {'tomtom/tcomment_vim'} -- Commenter plugin
paq {'Chiel92/vim-autoformat'} -- Integration with code formatters
paq {'tpope/vim-fugitive'} -- Git wrapper
paq {'dense-analysis/ale'} -- Asynchronous linting
paq {'cespare/vim-toml'}

-- Completion plugins
-- paq {'shougo/deoplete-lsp'}
-- paq {'shougo/deoplete.nvim', hook = fn['remote#host#UpdateRemotePlugins']}
paq {'hrsh7th/nvim-compe'}
paq {'ervandew/supertab'} -- Perform all your Vim insert mode completions with Tab

paq {'neovim/nvim-lspconfig'}
paq {'ojroques/nvim-lspfuzzy'}

-- Miscellaneous plugins
paq {'junegunn/fzf'} -- TODO: do not install, check for system fzf
paq {'junegunn/fzf.vim'}

-- Display plugins
paq {'bchretien/vim-hybrid'} -- Color scheme
paq {'glepnir/galaxyline.nvim'}
paq {'mhinz/vim-signify'} -- Show a VCS diff using Vim's sign column
paq {'mhinz/vim-startify'} -- Fancy start screen

-------------------- OPTIONS -------------------------------
local indent = 2
cmd 'colorscheme hybrid'                   -- Put your favorite colorscheme here
opt('b', 'expandtab', true)                -- Use spaces instead of tabs
opt('b', 'shiftwidth', indent)             -- Size of an indent
opt('b', 'smartindent', true)              -- Insert indents automatically
opt('b', 'tabstop', indent)                -- Number of spaces tabs count for
opt('o', 'hidden', true)                   -- Enable modified buffers in background
opt('o', 'ignorecase', true)               -- Ignore case
opt('o', 'joinspaces', false)              -- No double spaces with join after a dot
opt('o', 'scrolloff', 4 )                  -- Lines of context
opt('o', 'shiftround', true)               -- Round indent
opt('o', 'sidescrolloff', 8 )              -- Columns of context
opt('o', 'smartcase', true)                -- Don't ignore case with capitals
opt('o', 'splitbelow', true)               -- Put new windows below current
opt('o', 'splitright', true)               -- Put new windows right of current
opt('o', 'termguicolors', true)            -- True color support
opt('o', 'wildmode', 'longest:full,full')  -- Command-line completion mode
opt('o', 'clipboard', 'unnamed,unnamedplus') -- Use system clipboard
opt('w', 'list', true)                     -- Show some invisible characters (tabs etc.)
opt('w', 'number', true)                   -- Print line number
opt('w', 'relativenumber', true)           -- Relative line numbers
opt('w', 'wrap', false)                    -- Disable line wrap

opt('o', 'spell', false)                   -- Spell checking off
opt('o', 'history', 1000)                  -- Store a ton of history
opt('o', 'virtualedit', 'block')           -- Allow virtual editing in Visual block mode
opt('o', 'background', 'dark')             -- Assume a dark background
opt('b', 'swapfile', false)                -- Disable swap files
opt('o', 'backup', false)                  -- Disable swap backups

opt('o', 'undolevels', 1000)
opt('o', 'undoreload', 10000)
opt('o', 'undodir', os.getenv('HOME')..'/.local/share/nvim/tmp/undo')
opt('o', 'undofile', true)

------------------------------------------------------------------------
--                             Functions                              --
------------------------------------------------------------------------

-- Easy zooming
function ZoomToggle()
  if vim.t.zoomed == 1 then
    vim.api.nvim_exec(vim.t.zoom_winrestcmd, false)
    vim.t.zoomed = 0
  else
    vim.t.zoom_winrestcmd = vim.call('winrestcmd')
    vim.cmd('resize')
    vim.cmd('vertical resize')
    vim.t.zoomed = 1
  end
end

-- Strip trailing whitespaces
function StripTrailingWhitespace()
  local ft = vim.api.nvim_exec('echo &filetype', true)
  if ft ~= 'diff' then
    vim.cmd([[normal mz]])
    vim.cmd([[normal Hmy]])
    vim.cmd([[%s/\s\+$//e]])
    vim.cmd([[normal 'yz<CR>]])
    vim.cmd([[normal `z]])
  end
end
vim.cmd([[command! StripTrailingWhitespace call v:lua.StripTrailingWhitespace()]])

-- See: http://stackoverflow.com/a/7321131/1043187
-- TODO: convert to Lua
vim.api.nvim_exec(
[[
function! DeleteInactiveBufs()
  " From tabpagebuflist() help, get a list of all buffers in all tabs
  let tablist = []
  for i in range(tabpagenr('$'))
    call extend(tablist, tabpagebuflist(i + 1))
  endfor

  " Below originally inspired by Hara Krishna Dara and Keith Roberts
  " http://tech.groups.yahoo.com/group/vim/message/56425
  let nWipeouts = 0
  for i in range(1, bufnr('$'))
    if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
      " bufno exists AND isn't modified AND isn't in the list of buffers open
      " in windows and tabs
      silent exec 'bwipeout!' i
      let nWipeouts = nWipeouts + 1
    endif
  endfor
  echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()
]],
false)

-- See: http://stackoverflow.com/questions/290465/vim-how-to-paste-over-without-overwriting-register
-- TODO: convert to Lua
vim.api.nvim_exec(
[[
function! Paste()
  if col('.') == col('$') - 1
    return '"_dp'
  else
    return '"_dP'
  endif
endfunction
xnoremap <expr> p Paste()
xnoremap <expr> P Paste()
]],
false)

vim.api.nvim_exec(
[[
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
]],
false)

------------------------------------------------------------------------
--                              Mappings                              --
------------------------------------------------------------------------

-- Leader key
g.mapleader = " "
g.maplocalleader = g.mapleader
map('n', ',', '<space>')
map('v', ',', '<space>')

map('n', '<C-l>', '<cmd>noh<CR>')    -- Clear highlights
-- map('n', '<leader>o', 'm`o<Esc>``')  -- Insert a newline in normal mode

-- File formatting
map('n', '<leader>cf', ':Autoformat<cr>')

-- Easier formatting
map('n', '<leader>q', 'gwip', {silent = true})
map('v', '<leader>q', 'gw', {silent = true})

-- qq to record, Q to replay (plus disable Ex mode)
map('n', 'Q', '@q')

-- Select pasted text
map('n', 'gp', '"`[" . strpart(getregtype(), 0, 1) . "`]"', {expr = true, noremap = true})

-- FIXME: Enable 'very magic' mode
-- map('n', '/', '/v', {noremap = true})
-- map('v', '/', '/v', {noremap = true})
-- map('c', '%s', '%smagic/', {noremap = true})
-- map('c', '>s/', '>smagic/', {noremap = true})

-- Visual shifting (does not exit Visual mode)
map('v', '<', '<gv', {noremap = true})
map('v', '>', '>gv', {noremap = true})

-- Easy zooming
map('n', '<leader><leader>', ':call v:lua.ZoomToggle()<cr>', {noremap = true, silent = true})

-- Navigation
map('n', 'j', 'gj', {noremap = true})
map('n', 'k', 'gk', {noremap = true})
map('x', 'j', 'gj', {noremap = true})
map('x', 'k', 'gk', {noremap = true})

-- Navigation for tabs
map('n', 'th', ':tabfirst<CR>', {noremap = true})
map('n', 'tj', ':tabprev<CR>', {noremap = true})
map('n', 'tk', ':tabnext<CR>', {noremap = true})
map('n', 'tl', ':tablast<CR>', {noremap = true})
map('n', 'tm', ':tabm<Space>', {noremap = true})
map('n', 'tn', ':tabnew<CR>', {noremap = true})
map('n', 'td', ':tabclose<CR>', {noremap = true})
map('n', 'tt', ':tabnext<CR>', {noremap = true})

-- Start the find and replace command from the cursor position to the end of the file
map('v', '<leader>z', [[<Esc>:,$s/<c-r>=GetVisual()<cr>/]], {noremap = true})
-- Start the find and replace command across the whole file
map('v', '<leader>zz', [[<Esc>:%s/<c-r>=GetVisual()<cr>/]], {noremap = true})

------------------------------------------------------------------------
--                                Ale                                 --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'ale') then
  g.ale_linters = {
    cpp = { 'clangtidy' },
    lua = { 'luacheck' },
    rust = { 'analyzer' },
  }

  -- (optional, for completion performance) run linters only when I save files
  g.ale_lint_on_text_changed = 'never'
  g.ale_lint_on_enter = 0

  g.ale_lua_luacheck_options = '--no-max-line-length --ignore "113"'
end

------------------------------------------------------------------------
--                             auto-pairs                             --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'auto-pairs') then
  g.AutoPairs = {
    ['['] = ']',
    ['{'] = '}',
    ["'"] = "'",
    ['"'] = '"',
    ['`'] = '`'
  }
  g.AutoPairsFlyMode = 0
  g.AutoPairsMultilineClose = 0
end

------------------------------------------------------------------------
--                              deoplete                              --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'deoplete') then
  g['deoplete#enable_at_startup'] = 1  -- enable deoplete at startup
  cmd 'call deoplete#custom#source("_", "min_pattern_length", 2)'
  -- cmd 'call deoplete#custom#source("LanguageClient", "min_pattern_length", 2)'

  -- Disable the candidates in Comment/String syntaxes.
  cmd 'call deoplete#custom#source("_", "disabled_syntaxes", ["Comment", "String"])'
end

------------------------------------------------------------------------
--                         DoxygenToolkit.vim                         --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'DoxygenToolkit.vim') then
  -- Use C++ here for /// doxygen doc, else /** */ is used.
  g.DoxygenToolkit_commentType = "C++"
  -- Leading character used for @brief, @param...
  g.DoxygenToolkit_versionString = "\\"
  -- Comment block with ,d
  map('n', '<leader>d', ':Dox<cr>')

  g.DoxygenToolkit_briefTag_pre = "\\brief "
  g.DoxygenToolkit_paramTag_pre = "\\param "
  g.DoxygenToolkit_templateParamTag_pre = "\\tparam "
  g.DoxygenToolkit_throwTag_pre = "\\throw "
  g.DoxygenToolkit_returnTag = "\\return "
  g.DoxygenToolkit_blockHeader = ""
  g.DoxygenToolkit_blockFooter = ""
  -- TODO
  g.DoxygenToolkit_authorName = "My Name"
end

------------------------------------------------------------------------
--                              fzf.vim                               --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'fzf.vim') and #vim.fn.systemlist('which fzf') > 0 then
  -- Disable statusline overwriting
  g.fzf_nvim_statusline = 0

  g.fzf_layout = {down = '30%' }

  -- Ctrl-P without fuzzy search
  map('n', '<C-p>', ':FZF -e --cycle<cr>')

  -- Ctrl-Space to see buffers
  map('n', '<C-space>', ':Buffers<cr>')

  -- Grep-like search
  map('n', '<leader>/', ':Rg ', {noremap = true})
  map('v', '<leader>/', [[y:Rg <C-R>=escape(@", '\\.*$^[]')<cr><cr>]], {noremap = true})
end

------------------------------------------------------------------------
--                          galaxyline.nvim                           --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'galaxyline.nvim') then
  local gl = require('galaxyline')
  local gls = gl.section

  local colors = {
    bg = '#1c1c1c',
    fg = '#f5f5f5',

    bg2 = '#3a3a3a',
    fg2 = '#afaf87',

    yellow = '#fabd2f',
    cyan = '#008080',
    darkblue = '#081633',
    -- orange = '#FF8800',
    purple = '#5d4d7a',
    magenta = '#d16d9e',
    grey = '#242424',

    white = '#ffffff',
    red = '#870000',
    green = '#5f8700',
    blue = '#005fff',
    orange = '#d75f00',
  }

  -- auto change color according the vim mode
  local mode_color = {
    n = colors.blue,
    i = colors.green,
    v = colors.orange,
    V = colors.orange,
    [''] = colors.orange,
    R = colors.red,
    c = colors.grey,

    no = colors.magenta,
    s = colors.orange,
    S = colors.orange,
    [''] = colors.orange,
    ic = colors.yellow,
    Rv = colors.purple,
    cv = colors.red,
    ce = colors.red,
    r = colors.cyan,
    rm = colors.cyan,
    ['r?'] = colors.cyan,
    ['!']  = colors.red,
    t = colors.red
  }

  -- Mode with associated color
  gls.left[1] = {
    ViMode = {
      provider = function()
        vim.cmd('hi GalaxyViMode guifg='..colors.fg..' guibg='..mode_color[vim.fn.mode()]..' gui=bold')

        local alias = {
          n = 'NORMAL',
          i = 'INSERT',
          c = 'COMMAND',
          v = 'VISUAL',
          V = 'VISUAL',
          [''] = ' VISUAL',
          R = 'REPLACE',
        }
        return alias[vim.fn.mode()]
      end,
    },
  }

  -- Separator whose color changes according to mode
  gls.left[2] = {
    ViModeSep = {
      provider = function()
        vim.cmd('hi GalaxyViModeSep guifg='..mode_color[vim.fn.mode()]..' guibg='..colors.bg)
        return ' '
      end,
    },
  }

  gls.right[1] = {
    LineInfo = {
      provider = 'LineColumn',
      separator = '',
      separator_highlight = {colors.bg2, colors.bg},
      highlight = {colors.fg2, colors.bg2},
    },
  }
  gls.right[2] = {
    PerCent = {
      provider = 'LinePercent',
      separator = '',
      separator_highlight = {colors.bg, colors.bg2},
      highlight = {colors.fg, colors.bg},
    }
  }

  gls.right[3]= {
    FileFormat = {
      provider = 'FileFormat',
      separator = '',
      separator_highlight = {colors.bg2, colors.bg},
      highlight = {colors.fg2, colors.bg2},
    }
  }

  gls.right[4] = {
    FileEncode = {
      -- provider = 'FileEncode',
      provider = function()
        -- Workaround for bug in galaxyline.nvim
        return string.sub(require('galaxyline.provider_fileinfo').get_file_encode(), 2)
      end,
      separator = '',
      separator_highlight = {colors.bg, colors.bg2},
      highlight = {colors.fg2, colors.bg2},
    }
  }

  gls.right[5] = {
    FileTypeName = {
      -- provider = 'FileTypeName',
      provider = function()
        return string.lower(require('galaxyline.provider_buffer').get_buffer_filetype())
      end,
      separator = '',
      separator_highlight = {colors.bg, colors.bg2},
      highlight = {colors.fg2, colors.bg2},
    }
  }
end

------------------------------------------------------------------------
--                             nvim-compe                             --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'nvim-compe') then
  require'compe'.setup {
    enabled = true;
    debug = false;
    min_length = 2;
    preselect = 'disable'; -- 'enable', 'disable' or 'always';
    -- throttle_time = ... number ...;
    -- source_timeout = ... number ...;
    -- incomplete_delay = ... number ...;
    allow_prefix_unmatch = false;

    source = {
      buffer = true;
      nvim_lsp = true;
      path = true;
      ultisnips = true;
      vsnip = false;
      -- nvim_lua = { ... overwrite source configuration ... };
    };
  }
end

------------------------------------------------------------------------
--                              supertab                              --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'supertab') then
  g.SuperTabDefaultCompletionType = '<Tab>'
  g.SuperTabBackward = '<C-S-Tab>'
  g.SuperTabCrMapping = 1
end

------------------------------------------------------------------------
--                             ultisnips                              --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'ultisnips') then
  -- Trigger configuration.
  g.UltiSnipsExpandTrigger = "<tab>"
  g.UltiSnipsJumpForwardTrigger = "<tab>"
  g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
  g.UltiSnipsListSnippets = "<c-tab>"

  -- If you want :UltiSnipsEdit to split your window.
  g.UltiSnipsEditSplit = "vertical"

  -- Custom snippets
  g.UltiSnipsSnippetsDir = nvim_dir .. '/custom_snippets'
  g.UltiSnipsSnippetDirectories = {"UltiSnips", "custom_snippets"}

  g.ultisnips_python_style = "numpy"
end

------------------------------------------------------------------------
--                           vim-easy-align                           --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'vim-easy-align') then
  -- Start interactive EasyAlign in visual mode
  map('v', '<enter>', '<Plug>(EasyAlign)')

  -- Start interactive EasyAlign with a Vim movement
  map('n', '<leader>a', '<Plug>(EasyAlign)')

  g.easy_align_delimiters = {
    [' '] = { pattern = ' ', left_margin = 0, right_margin = 0, stick_to_left = 0 },
    ['+'] = { pattern = '+', left_margin = 1, right_margin = 1, stick_to_left = 0 },
    ['-'] = { pattern = '-', left_margin = 1, right_margin = 1, stick_to_left = 0 },
    ['='] = { pattern = [[===\|<=>\|\(&&\|||\|<<\|>>\)=\|=\~[#?]\?\|=>\|[:+/*!%^=><&|.-]\?=[#?]\?]], left_margin = 1, right_margin = 1, stick_to_left = 0 },
    [':'] = { pattern = ':', left_margin = 0, right_margin = 1, stick_to_left = 1 },
    [','] = { pattern = ',', left_margin = 0, right_margin = 1, stick_to_left = 1 },
    ['|'] = { pattern = '|', left_margin = 1, right_margin = 1, stick_to_left = 0 },
    ['.'] = { pattern = '.', left_margin = 0, right_margin = 0, stick_to_left = 0 },
    ['&'] = { pattern = [[\\\@<!&\|\\\\]], left_margin = 1, right_margin = 1, stick_to_left = 0 },
    ['{'] = { pattern = [[(\@<!{]], left_margin = 1, right_margin = 1, stick_to_left = 0 },
    ['}'] = { pattern = '}', left_margin = 1, right_margin = 0, stick_to_left = 0 },
    ['\\'] = { pattern = '\\', left_margin = 1, right_margin = 0, stick_to_left = 0 },
    ['<'] = { pattern = '<', left_margin = 1, right_margin = 0, stick_to_left = 0 },
    ['d'] = { pattern = [[ \(\S\+\s*[;=]\)\@=]], left_margin = 0, right_margin = 0},
    ['#'] = { pattern = '#', left_margin = 1, right_margin = 1, stick_to_left = 0 },
    ['['] = { pattern = [[(\@<![]], left_margin = 1, right_margin = 1, stick_to_left = 0 },
    [']'] = { pattern = ']', left_margin = 1, right_margin = 0, stick_to_left = 0 },
  }
end

------------------------------------------------------------------------
--                            vim-startify                            --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'vim-startify') then
  g.startify_files_number = 5

  g.startify_list_order = {{'-- Bookmarks --'}, 'bookmarks', {'-- Sessions --'}, 'sessions', {'-- Recent files --'}, 'files'}
  g.startify_bookmarks = { nvim_dir .. '/init.lua' }
  g.startify_session_dir = nvim_dir .. '/sessions'

  -- Skip list
  g.startify_skiplist = { '^/tmp' }


  local function SplitLines(str)
    local lines = {}
    for s in str:gmatch("[^\r\n]+") do
      table.insert(lines, s)
    end
    return lines
  end

  local function CowSay()
    local command = 'cowsay -f "$(ls /usr/share/cowsay/cows/ | grep -vE "head|sod|kiss|surg|tele" | sort -R | head -1)" "$(fortune -s)"'
    local handle = io.popen(command, 'r')
    local result = handle:read("*a")
    handle:close()
    return result
  end

  -- Call fortune and cowsay (if present)
  g.startify_custom_header = SplitLines(CowSay())
end

------------------------------------------------------------------------
--                             vim-sneak                              --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'vim-sneak') then
  -- Use Sneak as a minimalist alternative to EasyMotion
  g["sneak#streak"] = 1

  -- replace 'f' with 1-char Sneak
  map('n', 'f', '<Plug>Sneak_f', {noremap = false})
  map('x', 'f', '<Plug>Sneak_f', {noremap = false})
  map('o', 'f', '<Plug>Sneak_f', {noremap = false})

  map('n', 'F', '<Plug>Sneak_F', {noremap = false})
  map('x', 'F', '<Plug>Sneak_F', {noremap = false})
  map('o', 'F', '<Plug>Sneak_F', {noremap = false})

  -- replace 't' with 1-char Sneak
  map('n', 't', '<Plug>Sneak_t', {noremap = false})
  map('x', 't', '<Plug>Sneak_t', {noremap = false})
  map('o', 't', '<Plug>Sneak_t', {noremap = false})

  map('n', 'T', '<Plug>Sneak_T', {noremap = false})
  map('x', 'T', '<Plug>Sneak_T', {noremap = false})
  map('o', 'T', '<Plug>Sneak_T', {noremap = false})
end

------------------------------------------------------------------------
--                             treesitter                             --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'nvim-treesitter') then
  local ts = require 'nvim-treesitter.configs'
  ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

  opt('w', 'foldmethod', 'expr')
  opt('w', 'foldexpr', 'nvim_treesitter#foldexpr()')
  opt('w', 'foldenable', false)
end

------------------------------------------------------------------------
--                                LSP                                 --
------------------------------------------------------------------------

if isdir(plugins_dir .. 'nvim-lspconfig') then
  local lsp = require 'lspconfig'

  -- root_dir is where the LSP server will start: here at the project root otherwise in current folder
  if #vim.fn.systemlist('which ccls') > 0 then
    lsp.ccls.setup {root_dir = lsp.util.root_pattern('.git', fn.getcwd())}
  elseif #vim.fn.systemlist('which clangd') > 0 then
    lsp.clangd.setup {root_dir = lsp.util.root_pattern('.git', fn.getcwd())}
  end

  if #vim.fn.systemlist('which pyls') > 0 then
    lsp.pyls.setup {root_dir = lsp.util.root_pattern('.git', fn.getcwd())}
  end

  if #vim.fn.systemlist('which rust-analyzer') > 0 then
    lsp.rust_analyzer.setup {
      cmd = { 'rust-analyzer' },
      root_dir = lsp.util.root_pattern('Cargo.toml', fn.getcwd()),
      settings = {
        ["rust-analyzer"] = {
          updates = {
            channel = 'nightly'
          },
          procMacro = {
            enable = true,
          }
        }
      }
    }
  elseif #vim.fn.systemlist('which rls') > 0 then
    lsp.rls.setup {
      cmd = { 'rustup', 'run', 'nightly', 'rls' },
      root_dir = lsp.util.root_pattern('Cargo.toml', fn.getcwd()),
      settings = {
        rust = {
          unstable_features = true,
          build_on_save = false,
          all_features = true,
        },
      },
    }
  end

  map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
  map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
  map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
end

if isdir(plugins_dir .. 'nvim-lspfuzzy') then
  local lspfuzzy = require 'lspfuzzy'
  lspfuzzy.setup {}  -- Make the LSP client use FZF instead of the quickfix list
end

------------------------------------------------------------------------
--                              Commands                              --
------------------------------------------------------------------------

cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'  -- disabled in visual mode

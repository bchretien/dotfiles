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

-- Bootstrap packer.nvim
local fn = vim.fn
local plugins_dir = fn.stdpath('data')..'/site/pack/packer/start/'
local opt_plugins_dir = fn.stdpath('data')..'/site/pack/packer/opt/'
local install_path = plugins_dir .. 'packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  vim.api.nvim_echo({{'Installing packer.nvim', 'Type'}}, true, {})
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function binary_exists(name)
  return os.execute('type ' .. name .. ' &>/dev/null') == 0
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

local function has_plugin(name)
  return isdir(plugins_dir .. name) or isdir(opt_plugins_dir .. name)
end


-- Save copied tables in `copies`, indexed by original table.
local function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-------------------- PLUGINS -------------------------------
cmd 'packadd packer.nvim' -- load the package manager
packer = require 'packer'
packer.init { disable_commands = false }
packer.reset()

packer.use {
  'wbthomason/packer.nvim'
}

-- Edition plugins
packer.use 'mg979/vim-visual-multi'
packer.use 'tpope/vim-surround'
packer.use 'ggandor/lightspeed.nvim'
packer.use 'junegunn/vim-easy-align' -- TODO: lazy loading
packer.use 'sirver/ultisnips' -- UltiSnips engine
packer.use 'honza/vim-snippets' -- Snippets
packer.use 'jiangmiao/auto-pairs' -- Auto-close feature for parentheses, brackets etc.
packer.use 'nvim-treesitter/nvim-treesitter'

-- Development plugins
packer.use {
  'kkoomen/vim-doge',
  run = ':call doge#install()',
  -- FIXME: lazy loading
  -- cmd = 'DogeGenerate',
}

packer.use 'tomtom/tcomment_vim' -- Commenter plugin
packer.use 'Chiel92/vim-autoformat' -- Integration with code formatters
packer.use 'tpope/vim-fugitive' -- Git wrapper
packer.use 'dense-analysis/ale' -- Asynchronous linting
packer.use {
  'cespare/vim-toml',
  ft = 'toml',
}

-- Completion plugins
packer.use {
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'quangnguyen30192/cmp-nvim-ultisnips',
  }
}
packer.use 'ervandew/supertab' -- Perform all your Vim insert mode completions with Tab

packer.use 'neovim/nvim-lspconfig'
packer.use {
  -- FIXME: move back to glepnir as soon as he remaintains it
  'tami5/lspsaga.nvim',
  requires = {
    'neovim/nvim-lspconfig'
  }
}
packer.use 'ojroques/nvim-lspfuzzy'

-- Miscellaneous plugins
packer.use {
  'nvim-telescope/telescope.nvim',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-frecency.nvim',
    'nvim-telescope/telescope-fzf-native.nvim',
  },
  -- FIXME: lazy loading
  -- setup = [[require('config.telescope_setup')]],
  -- config = [[require('config.telescope')]],
  -- cmd = 'Telescope',
  -- module = 'telescope',
}

packer.use  {
  'nvim-telescope/telescope-frecency.nvim',
  after = 'telescope.nvim',
  requires = 'tami5/sql.nvim',
}

packer.use {
  'nvim-telescope/telescope-fzf-native.nvim',
  run = 'make',
}

packer.use {
  'ahmedkhalf/project.nvim',
  requires = 'nvim-telescope/telescope.nvim',
}

packer.use {
  'folke/trouble.nvim',
  requires = {
    'kyazdani42/nvim-web-devicons',
    'folke/lsp-colors.nvim',
  },
}

-- Display plugins
packer.use 'bchretien/vim-hybrid' -- Color scheme
packer.use 'glepnir/galaxyline.nvim'
packer.use {
  'lewis6991/gitsigns.nvim',
  requires = {
    'nvim-lua/plenary.nvim'
  },
  tag = 'release'
}

packer.use 'mhinz/vim-startify' -- Fancy start screen

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

if has_plugin('ale') then
  g.ale_linters = {
    cpp = { 'clangtidy' },
    python = { 'mypy', 'pyright', 'pyflakes', 'pylint' },
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

if has_plugin('auto-pairs') then
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

if has_plugin('deoplete') then
  g['deoplete#enable_at_startup'] = 1  -- enable deoplete at startup
  cmd 'call deoplete#custom#source("_", "min_pattern_length", 2)'
  -- cmd 'call deoplete#custom#source("LanguageClient", "min_pattern_length", 2)'

  -- Disable the candidates in Comment/String syntaxes.
  cmd 'call deoplete#custom#source("_", "disabled_syntaxes", ["Comment", "String"])'
end

------------------------------------------------------------------------
--                         DoxygenToolkit.vim                         --
------------------------------------------------------------------------

if has_plugin('DoxygenToolkit.vim') then
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

if has_plugin('fzf.vim') and binary_exists('fzf') then
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

if has_plugin('galaxyline.nvim') then
  local gl = require('galaxyline')
  local gls = gl.section
  local glc = require('galaxyline.condition')

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
        vim.cmd('hi GalaxyViModeSep guifg='..mode_color[vim.fn.mode()]..' guibg='..colors.bg2)
        return ' '
      end,
    },
  }

  gls.left[3] = {
    FileName = {
      -- provider = 'FileName',
      provider = function()
        name = string.lower(require('galaxyline.provider_fileinfo').filename_in_special_buffer())
        if name == '' then return '(empty)' else return name end
      end,
      separator = ' ',
      separator_highlight = {colors.bg2, colors.bg},
      highlight = {colors.fg2, colors.bg2},
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
--                           gitsigns.nvim                            --
------------------------------------------------------------------------

if has_plugin('gitsigns.nvim') then
  vim.api.nvim_command[[autocmd ColorScheme * highlight GitSignsChange ctermbg=black ctermfg=24 guibg=none guifg=#5dade2]]

  require('gitsigns').setup {
    signs = {
      add          = {hl = 'GitSignsAdd'   , text = '▋+', numhl='GitSignsAdd'   , linehl='GitSignsAdd'},
      change       = {hl = 'GitSignsChange', text = '▋~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      delete       = {hl = 'GitSignsDelete', text = '▋-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      topdelete    = {hl = 'GitSignsDelete', text = '▋?', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      changedelete = {hl = 'GitSignsChange', text = '▋!', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
  }
end

------------------------------------------------------------------------
--                          lightspeed.nvim                           --
------------------------------------------------------------------------

if has_plugin('lightspeed.nvim') then
end

------------------------------------------------------------------------
--                            lspsaga.nvim                            --
------------------------------------------------------------------------

if has_plugin('lspsaga.nvim') then
  local saga = require 'lspsaga'
  saga.init_lsp_saga()

  map('n', '<space>gh', '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>', {noremap = false, silent = true})
  map('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', {noremap = false, silent = true})
  map('v', '<leader>ca', ':<C-U>lua require("lspsaga.codeaction").code_action()<CR>', {noremap = false, silent = true})
  map('n', 'K', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', {noremap = false, silent = true})
  map('n', 'gs', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', {noremap = false, silent = true})
  map('n', 'gr', '<cmd>lua require("lspsaga.rename").rename()<CR>', {noremap = false, silent = true})
  map('n', '<leader>gd', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>', {noremap = false, silent = true})
end

------------------------------------------------------------------------
--                             nvim-cmp                             --
------------------------------------------------------------------------

if has_plugin('nvim-cmp') then
  local cmp = require'cmp'
  cmp.setup({
    preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        -- For `ultisnips` user.
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'ultisnips' },
      { name = 'buffer' },
      { name = 'path' },
    }
  })
end

------------------------------------------------------------------------
--                              supertab                              --
------------------------------------------------------------------------

if has_plugin('supertab') then
  g.SuperTabDefaultCompletionType = '<Tab>'
  g.SuperTabBackward = '<C-S-Tab>'
  g.SuperTabCrMapping = 1
end

------------------------------------------------------------------------
--                             ultisnips                              --
------------------------------------------------------------------------

if has_plugin('ultisnips') then
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
--                              vim-doge                              --
------------------------------------------------------------------------

if has_plugin('vim-doge') then
  g.doge_doc_standard_python = 'numpy'
end

------------------------------------------------------------------------
--                           vim-easy-align                           --
------------------------------------------------------------------------

if has_plugin('vim-easy-align') then
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

if has_plugin('vim-startify') then
  g.startify_files_number = 5

  g.startify_list_order = {{'-- Bookmarks --'}, 'bookmarks', {'-- Sessions --'}, 'sessions', {'-- Recent files --'}, 'files'}
  g.startify_bookmarks = { nvim_dir .. 'init.lua' }
  g.startify_session_dir = nvim_dir .. 'sessions'

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
    if binary_exists('cowsay') and binary_exists('fortune') then
      local command = 'cowsay -f "$(ls /usr/share/cowsay/cows/ | grep -vE "head|sod|kiss|surg|tele" | sort -R | head -1)" "$(fortune -s)"'
      local handle = io.popen(command, 'r')
      local result = handle:read("*a")
      handle:close()
      return result
    end
    return ""
  end

  -- Call fortune and cowsay (if present)
  g.startify_custom_header = SplitLines(CowSay())
end

------------------------------------------------------------------------
--                             vim-sneak                              --
------------------------------------------------------------------------

if has_plugin('vim-sneak') then
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
--                           telescope.nvim                           --
------------------------------------------------------------------------

if has_plugin('telescope.nvim') then
  require'telescope'.setup({})

  -- Modified version of the ivy theme
  ivy_small = require('telescope.themes').get_ivy()
  ivy_small['layout_config']['height'] = 10

  -- Ctrl-P
  map('n', '<C-p>', ':lua require("telescope.builtin").find_files(ivy_small)<cr>')

  -- Ctrl-Space to see buffers
  -- FIXME: Ctrl-Space not working on OSX with tmux?!
  map('n', '<C-space>', ':lua require("telescope.builtin").buffers(ivy_small)<cr>')

  -- Grep-like search
  -- map('n', '<leader>/', ':lua require("telescope.builtin").live_grep(ivy_small)<cr>', {noremap = true})
  ivy_small_grep_string = deepcopy(ivy_small)
  ivy_small_grep_string['path_display'] = { truncate = 70 }
  ivy_small_grep_string['only_sort_text'] = true
  ivy_small_grep_string['search'] = ""
  map('n', '<leader>/', ':lua require("telescope.builtin").grep_string(ivy_small_grep_string)<cr>', {noremap = true})
  map('v', '<leader>/', ':lua require("telescope.builtin").grep_string(ivy_small)<cr>', {noremap = true})
end

------------------------------------------------------------------------
--                             treesitter                             --
------------------------------------------------------------------------

if has_plugin('nvim-treesitter') then
  local ts = require 'nvim-treesitter.configs'
  ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

  opt('w', 'foldmethod', 'expr')
  opt('w', 'foldexpr', 'nvim_treesitter#foldexpr()')
  opt('w', 'foldenable', false)
  opt('w', 'foldnestmax', 2)
end

------------------------------------------------------------------------
--                            project.nvim                            --
------------------------------------------------------------------------

if has_plugin('project.nvim') then
  require('project_nvim').setup {}

  -- Enable support in telescope
  require('telescope').load_extension('projects')
end

------------------------------------------------------------------------
--                            trouble.nvim                            --
------------------------------------------------------------------------

if has_plugin('trouble.nvim') then
  require('trouble').setup {
    height = 10,
    mode = 'lsp_document_diagnostics',
  }
end

------------------------------------------------------------------------
--                                LSP                                 --
------------------------------------------------------------------------

if has_plugin('nvim-lspconfig') then
  local lsp = require 'lspconfig'
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- root_dir is where the LSP server will start: here at the project root otherwise in current folder
  if binary_exists('ccls') then
    lsp.ccls.setup {
      root_dir = lsp.util.root_pattern('.git', fn.getcwd()),
      capabilities = capabilities,
    }
  elseif binary_exists('clangd') then
    lsp.clangd.setup {
      root_dir = lsp.util.root_pattern('.git', fn.getcwd()),
      capabilities = capabilities,
    }
  end

  if lsp.pyright and binary_exists('pyright') then
    lsp.pyright.setup {
      root_dir = lsp.util.root_pattern('.git', fn.getcwd()),
      capabilities = capabilities,
    }
  elseif lsp.pylsp and binary_exists('pylsp') then
    lsp.pylsp.setup {
      root_dir = lsp.util.root_pattern('.git', fn.getcwd()),
      capabilities = capabilities,
    }
  elseif lsp.pyls and binary_exists('pyls') then
    lsp.pyls.setup {
      root_dir = lsp.util.root_pattern('.git', fn.getcwd()),
      capabilities = capabilities,
    }
  end

  if binary_exists('rust-analyzer') then
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
  elseif binary_exists('rls') then
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
      capabilities = capabilities,
    }
  end

  map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
end

if has_plugin('nvim-lspfuzzy') then
  local lspfuzzy = require 'lspfuzzy'
  lspfuzzy.setup {}  -- Make the LSP client use FZF instead of the quickfix list
end

------------------------------------------------------------------------
--                              Commands                              --
------------------------------------------------------------------------

cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'  -- disabled in visual mode

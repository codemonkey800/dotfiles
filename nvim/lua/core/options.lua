local opt = vim.opt
local g = vim.g

-- Core settings
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

-- Increase pattern memory limit to prevent errors with complex patterns
opt.maxmempattern = 20000

-- Disable bells
opt.errorbells = false
opt.visualbell = false
vim.opt.belloff = 'all'

-- Encoding
opt.fileencoding = 'utf-8'

-- File formats/file handling
opt.backupcopy = 'yes'
opt.fileformat = 'unix'
opt.fileformats = 'unix,dos,mac'

-- Persistent undo
opt.undodir = '/tmp/nvim'
opt.undofile = true

-- Space style and size
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Text formatting
opt.cindent = true
opt.ignorecase = true
opt.smartcase = true
opt.smartindent = true

-- User interface
opt.completeopt = {'menu', 'menuone', 'noinsert', 'noselect'}
opt.foldlevelstart = 10
opt.foldmethod = 'syntax'
opt.hidden = true
opt.lazyredraw = true
opt.showmode = false
opt.wrap = false
opt.number = true
opt.report = 0
opt.showmatch = true
opt.relativenumber = true

-- True color support
if vim.fn.has('termguicolors') == 1 then
  opt.termguicolors = true
end

vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1

-- Colorscheme
local ok, _ = pcall(vim.cmd, 'colorscheme minimalist')
if not ok then
  vim.cmd('colorscheme default')
end
vim.cmd('hi Normal ctermbg=none guibg=none')
vim.cmd('hi NonText ctermbg=none guibg=none')
vim.cmd('hi LineNr ctermbg=none guibg=none')

-- GUI font
opt.guifont = 'Sauce Code Pro Nerd Font Complete Mono:h14'

-- Python host programs
if vim.fn.system('uname'):match('Darwin') then
  g.python_host_prog = '/opt/homebrew/bin/python2'
  g.python3_host_prog = '/opt/homebrew/bin/python3.10'
else
  g.python_host_prog = '/usr/bin/python2'
  g.python3_host_prog = '/usr/bin/python3'
end

g.python3_host_skip_check = 1

-- Force nvim to use bash for posix compatibility
if vim.o.shell:match('fish$') then
  opt.shell = 'bash'
end

-- WSL clipboard support
if vim.fn.system('uname -a'):find('Microsoft') then
  vim.g.clipboard = {
    name = 'DerpBoard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -Command Get-Clipboard',
      ['*'] = 'powershell.exe -Command Get-Clipboard',
    },
  }
end

-- Plugin settings (will be moved to plugin configs later)
-- vim-jsdoc
g.jsdoc_underscore_private = 1
g.jsdoc_enable_es6 = 1

-- easymotion
g.EasyMotion_do_mapping = 0
g.EasyMotion_smartcase = 1

-- vim-lexical
g.lexical_thesaurus = {'~/.config/nvim/mthesaur.txt'}
g.lexical_dictionary = {'/usr/share/dict/american-english'}

-- vim-polyglot
g.javascript_plugin_jsdoc = 1

-- vim-json
g.vim_json_syntax_conceal = 0

-- vim-jsx
g.jsx_ext_required = 0

-- vim-markdown
g.vim_markdown_folding_disabled = 1
g.vim_markdown_json_frontmatter = 1
g.vim_markdown_math = 1
g.vim_markdown_new_list_item_indent = 2

-- airline
g.airline_powerline_fonts = 1
g.airline_theme = 'minimalist'
g['airline#extensions#tabline#enabled'] = 1
g['airline#extensions#tabline#buffer_nr_show'] = 0
g['airline#extensions#tabline#show_tab_type'] = 0
g['airline#extensions#tabline#show_close_button'] = 0
g['airline#extensions#whitespace#enabled'] = 0
g.airline_skip_empty_sections = 1

-- chromatica.nvim
g['chromatica#enable_at_startup'] = 1
g['chromatica#responsive_mode'] = 1

-- tmux-navigator
g.tmux_navigator_no_mappings = 1

-- vim-editorconfig
g.EditorConfig_exclude_patterns = {'fugitive://.*'}
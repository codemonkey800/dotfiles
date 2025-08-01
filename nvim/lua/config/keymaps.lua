local map = vim.keymap.set
local fn = vim.fn
local cmd = vim.cmd

-- Set leader key
vim.g.mapleader = ','

-- Utility functions
local function smart_insert(key)
  return function()
    if vim.bo.buftype == 'terminal' then
      cmd('startinsert')
    elseif #vim.fn.getline('.') == 0 then
      return 'cc'
    else
      return key
    end
  end
end

local function buffer_count()
  local count = 0
  for i = 1, fn.bufnr('$') do
    if fn.buflisted(i) == 1 then
      count = count + 1
    end
  end
  return count
end

local function buffer_delete(force)
  force = force or false
  if fn.winnr('$') == 1 or buffer_count() == 1 then
    if force then
      cmd('bdelete!')
    else
      cmd('bdelete')
    end
  elseif not vim.bo.modified then
    cmd('bnext')
    if force then
      cmd('bdelete! #')
    else
      cmd('bdelete #')
    end
  end
end

local function execute_current_file()
  if fn.executable(fn.expand('%:p')) == 1 then
    cmd('!./%')
  end
end

local function clean_vim_plugins()
  cmd('PlugClean!')
  local old_plug = fn.fnamemodify(vim.env.MYVIMRC, ':p:h') .. '/autoload/plug.vim.old'
  fn.delete(old_plug)
end

local function toggle_spell()
  if vim.wo.spell then
    vim.wo.spell = false
  else
    vim.wo.spell = true
  end
end

-- Base maps
map('n', 'i', smart_insert('i'), { expr = true, silent = true })
map('n', 'a', smart_insert('a'), { expr = true, silent = true })

-- Improved <C-l>
map('n', '<C-l>', ':nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>', { silent = true })

-- Escape insert mode
map('i', '<C-c>', '<esc>', { silent = true })
map('i', 'jk', '<esc>', { silent = true })

-- Move vertically by visual line
map({'n', 'v'}, 'j', 'gj', { silent = true })
map({'n', 'v'}, 'k', 'gk', { silent = true })

-- Swap capital H and L for begin and end of lines
map({'n', 'v'}, 'H', '^', { silent = true })
map({'n', 'v'}, 'L', '$', { silent = true })

-- Quit and force quit maps
map('n', 'Q', ':q!<CR>', { silent = true })
map('n', 'q', ':q<CR>', { silent = true })

-- Space open/closes folds
map('n', '<space>', 'za')

-- Add new lines without entering insert mode
map('n', 'o', 'o<esc>k')
map('n', 'O', 'O<esc>j')

-- Redo
map('n', 'U', ':redo<CR>', { silent = true })

-- Save current file
map('n', '<C-s>', ':w<CR>', { silent = true })
map('i', '<C-s>', '<Esc>:w<CR>li', { silent = true })

-- Tag navigation
map('n', 'gt', '<C-]>', { silent = true })
map('n', 'gT', '<C-t>', { silent = true })
map('n', '<C-]>', '<nop>', { silent = true })
map('n', '<C-t>', '<nop>', { silent = true })

-- Buffer maps
map('n', '<leader>w', function() buffer_delete(false) end, { silent = true })
map('n', '<leader>W', function() buffer_delete(true) end, { silent = true })
map('n', '<leader>n', ':enew<CR>', { silent = true })
map('n', '<C-k>', ':bn<CR>', { silent = true })
map('n', '<C-j>', ':bp<CR>', { silent = true })

-- Fancy maps
map('n', '<leader>r', execute_current_file, { silent = true })

-- Sort
map('n', '<leader>sd', ':sort<CR>', { silent = true })
map('n', '<leader>sa', ':sort!<CR>', { silent = true })

-- Nvim config
map('n', '<leader>ve', ':edit $MYVIMRC<CR>', { silent = true })
map('n', '<leader>vs', ':source $MYVIMRC<CR>', { silent = true })

-- Select all
map('n', '<leader>a', 'ggvG$', { silent = true })

-- Lazy.nvim mappings (replacing Plug mappings)
map('n', '<leader>pc', ':Lazy clean<CR>', { silent = true })
map('n', '<leader>pi', ':Lazy install<CR>', { silent = true })
map('n', '<leader>ps', ':Lazy<CR>', { silent = true })
map('n', '<leader>pu', ':Lazy update<CR>', { silent = true })

-- System clipboard
map({'n', 'v'}, '<leader>y', '"+y', { silent = true })
map('n', '<leader>p', '"+p', { silent = true })

-- Command edit
map({'n', 'v'}, '<M-c>', 'q:', { silent = true })

-- Terminal
map('n', '~', ':edit term://fish<CR>i', { silent = true })
map('t', 'jk', '<C-\\><C-n>', { silent = true })
map('t', '<Esc>', '<C-\\><C-n>', { silent = true })

-- Search for visually selected text
map('v', '*', 'y/<C-R>"<CR>', { silent = true })

-- Spell toggle
map('n', '<M-s>', toggle_spell, { silent = true })

-- Plugin mappings

-- EasyAlign
map('x', 'ga', '<Plug>(EasyAlign)', { silent = true })
map('n', 'ga', '<Plug>(EasyAlign)', { silent = true })

-- EasyMotion
map({'n', 'o', 'v'}, 'sw', '<Plug>(easymotion-bd-f2)', { silent = true })
map('n', 'sw', '<Plug>(easymotion-overwin-f2)', { silent = true, remap = true })
map({'n', 'o', 'v'}, 'ss', '<Plug>(easymotion-bd-w)', { silent = true })
map('n', 'ss', '<Plug>(easymotion-overwin-w)', { silent = true, remap = true })
map({'n', 'o', 'v'}, 'sc', '<Plug>(easymotion-bd-jk)', { silent = true })
map('n', 'sc', '<Plug>(easymotion-overwin-line)', { silent = true, remap = true })

-- Incsearch
local function fuzzy_all(opts)
  opts = opts or {}
  return vim.tbl_extend('force', {
    converters = {
      fn['incsearch#config#fuzzy#converter'](),
      fn['incsearch#config#fuzzyspell#converter']()
    }
  }, opts)
end

map({'n', 'o', 'v'}, 'z/', function() return fn['incsearch#go'](fuzzy_all()) end, { expr = true, silent = true })
map({'n', 'o', 'v'}, 'z?', function() return fn['incsearch#go'](fuzzy_all({ command = '?' })) end, { expr = true, silent = true })
map({'n', 'o', 'v'}, 'zg/', function() return fn['incsearch#go'](fuzzy_all({ is_stay = 1 })) end, { expr = true, silent = true })

-- fzf-lua keymaps
map('n', '<C-p>', '<cmd>FzfLua files<CR>', { silent = true })
map('n', '<leader>ff', '<cmd>FzfLua files<CR>', { desc = 'Find files' })
map('n', '<leader>fg', '<cmd>FzfLua live_grep<CR>', { desc = 'Live grep' })
map('n', '<leader>fb', '<cmd>FzfLua buffers<CR>', { desc = 'Find buffers' })
map('n', '<leader>fh', '<cmd>FzfLua help_tags<CR>', { desc = 'Help tags' })
map('n', '<leader>fo', '<cmd>FzfLua oldfiles<CR>', { desc = 'Recent files' })
map('n', '<leader>fw', '<cmd>FzfLua grep_cword<CR>', { desc = 'Grep word under cursor' })
map('n', '<leader>fW', '<cmd>FzfLua grep_cWORD<CR>', { desc = 'Grep WORD under cursor' })
map('v', '<leader>fg', '<cmd>FzfLua grep_visual<CR>', { desc = 'Grep visual selection' })
map('n', '<leader>fd', '<cmd>FzfLua diagnostics_workspace<CR>', { desc = 'Workspace diagnostics' })
map('n', '<leader>fr', '<cmd>FzfLua resume<CR>', { desc = 'Resume last search' })

-- Tmux navigator
map('n', '<A-h>', ':TmuxNavigateLeft<CR>', { silent = true })
map('n', '<A-j>', ':TmuxNavigateDown<CR>', { silent = true })
map('n', '<A-k>', ':TmuxNavigateUp<CR>', { silent = true })
map('n', '<A-l>', ':TmuxNavigateRight<CR>', { silent = true })

-- Same for insert mode
map('i', '<A-h>', '<Esc>:TmuxNavigateLeft<CR>', { silent = true })
map('i', '<A-j>', '<Esc>:TmuxNavigateDown<CR>', { silent = true })
map('i', '<A-k>', '<Esc>:TmuxNavigateUp<CR>', { silent = true })
map('i', '<A-l>', '<Esc>:TmuxNavigateRight<CR>', { silent = true })

-- Terminal mode
map('t', '<A-h>', '<C-\\><C-n>:TmuxNavigateLeft<CR>', { silent = true })
map('t', '<A-j>', '<C-\\><C-n>:TmuxNavigateDown<CR>', { silent = true })
map('t', '<A-k>', '<C-\\><C-n>:TmuxNavigateUp<CR>', { silent = true })
map('t', '<A-l>', '<C-\\><C-n>:TmuxNavigateRight<CR>', { silent = true })
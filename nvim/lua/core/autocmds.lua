local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Core autocmds
local core_group = augroup('core_cmds', { clear = true })

-- Stop insert mode when leaving terminal buffer
autocmd('BufLeave', {
  group = core_group,
  pattern = 'term://*',
  command = 'stopinsert'
})

-- Fix whitespace before writing (requires vim-trailing-whitespace plugin)
autocmd('BufWritePre', {
  group = core_group,
  pattern = '*',
  command = 'FixWhitespace'
})

-- Open help windows vertically
autocmd('FileType', {
  group = core_group,
  pattern = 'help',
  command = 'wincmd L'
})

-- Lexical configuration for prose files
local lexical_group = augroup('lexical', { clear = true })

autocmd('FileType', {
  group = lexical_group,
  pattern = {'markdown', 'mkd', 'tex', 'text', 'textile'},
  callback = function()
    vim.fn['lexical#init']()
  end
})


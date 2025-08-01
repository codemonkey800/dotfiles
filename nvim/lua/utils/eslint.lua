local M = {}

function M.find_eslint()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then
    return ''
  end
  
  local parent_dir = vim.fn.fnamemodify(file, ':h')
  
  while parent_dir ~= '/' do
    local eslint = parent_dir .. '/node_modules/.bin/eslint'
    if vim.fn.filereadable(eslint) == 1 then
      return eslint
    end
    
    local next_dir = vim.fn.fnamemodify(parent_dir, ':h')
    if parent_dir == next_dir then
      return ''
    end
    parent_dir = next_dir
  end
  
  return ''
end

-- Make it available as a global function for compatibility
_G.FindEslint = M.find_eslint

return M
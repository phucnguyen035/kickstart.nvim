vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'rust', 'python' },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

local remember_fold = vim.api.nvim_create_augroup('RemeberFold', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWinLeave', 'BufWritePre' }, {
  pattern = '*.*',
  command = 'mkview',
  group = remember_fold,
})
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufWritePost' }, {
  pattern = '*.*',
  callback = function()
    vim.cmd 'silent! loadview'
  end,
  group = remember_fold,
})

-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', { noremap = true })

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

map('i', 'jk', '<ESC>', { desc = 'Exit insert mode', nowait = true })
map('i', '<C-h>', '<Left>', { desc = 'Move left' })
map('i', '<C-l>', '<Right>', { desc = 'Move right' })
map('i', '<C-k>', '<Up>', { desc = 'Move up' })
map('i', '<C-j>', '<Down>', { desc = 'Move down' })
map('i', '<C-b>', '<ESC><S-i>', { desc = 'Insert mode at beginning of char' })
map('i', '<C-e>', '<ESC><S-a>', { desc = 'Insert mode at end of char' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Jump half page down and keep cursor centered' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Jump half page up and keep cursor centered' })
map('n', 'n', 'nzzzv', { desc = 'Keep cursor centered when moving to next search result' })
map('n', 'N', 'Nzzzv', { desc = 'Keep cursor centered when moving to previous search result' })
map('n', '<M-o>', '@="m`o<C-V><Esc>``"<CR>', { desc = 'Insert newline below', silent = true })
map('n', '<M-O>', '@="m`O<C-V><Esc>``"<CR>', { desc = 'Insert newline above', silent = true })

if vim.g.vscode then
  map('n', '<leader><space>', '<cmd>Find<cr>')
  map('n', '<leader>fe', [[<cmd>call VSCodeNotify('workbench.view.explorer')<cr>]])
  map('n', '<leader>/', [[<cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>]])
  map('n', '<leader>ss', [[<cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>]])
  map('n', '<leader>gg', [[<cmd>call VSCodeNotify('workbench.view.scm')<cr>]])
  map('n', '<leader>pp', [[<cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<cr>]])
  map('n', '<leader>ps', [[<cmd>call VSCodeNotify('workbench.action.toggleAuxiliaryBar')<cr>]])
end

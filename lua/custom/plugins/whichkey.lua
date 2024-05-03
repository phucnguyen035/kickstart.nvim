return {
  'folke/which-key.nvim',
  cond = not vim.g.vscode,
  event = 'VeryLazy',
  config = function()
    local wk = require 'which-key'

    wk.register {
      ['<leader>c'] = {
        name = '+code/copilot',
        ['c'] = {
          name = '+chat',
        },
      },
      ['<leader>h'] = {
        name = '+harpoon',
      },
      ['<leader>f'] = {
        name = '+file',
      },
      ['<leader>s'] = {
        name = '+search',
      },
      ['<leader>g'] = {
        name = '+git',
      },
      ['<leader>b'] = {
        name = '+buffer',
        b = { '<cmd>b#<cr>', 'Switch to last buffer' },
        c = { '<cmd>WipeWindowlessBufs<cr>', 'Clear all buffers, keep current', { silent = true } },
      },
      ['<leader>x'] = {
        name = '+trouble',
      },
      ['<leader>t'] = {
        name = '+tab',
        g = { '<cmd>tabfirst<cr>', 'Go to first tab' },
        G = { '<cmd>tablast<cr>', 'Go to last tab' },
        n = { '<cmd>tabnew<cr>', 'New tab' },
      },
    }
  end,
}

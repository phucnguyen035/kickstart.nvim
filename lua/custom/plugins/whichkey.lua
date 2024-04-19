return {
  'folke/which-key.nvim',
  cond = not vim.g.vscode,
  event = 'VeryLazy',
  config = function()
    local wk = require 'which-key'

    wk.register {
      ['<leader>h'] = {
        name = '+Harpoon',
      },
      ['<leader>f'] = {
        name = '+File',
      },
      ['<leader>s'] = {
        name = '+Search',
        s = { '<cmd>Navbuddy<cr>', '[S]earch [S]ymbols' },
        r = '[S]earch and [R]eplace',
      },
      ['<leader>g'] = {
        name = '+Git',
      },
      ['<leader>d'] = {
        name = '+Debug',
      },
      ['<leader>b'] = {
        name = '+Buffer',
        l = { '<cmd>b#<cr>', '[B]uffer [L]ast' },
        d = { '<cmd>bd<cr>', '[B]uffer [D]elete' },
        c = { '<cmd>WipeWindowlessBufs<cr>', '[B]uffer [C]lose All But Current', { silent = true } },
      },
      ['<leader>x'] = {
        name = '+Trouble',
      },
      ['<leader>m'] = {
        name = '+Mini',
        s = {
          name = 'Sessions',
        },
      },
    }
  end,
}

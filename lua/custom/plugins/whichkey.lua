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
        c = { '<cmd>WipeWindowlessBufs<cr>', '[B]uffer [C]ear All But Current', { silent = true } },
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
      ['<leader>t'] = {
        name = '+Tab',
        h = { '<cmd>tabnext<cr>', 'Go to next tab' },
        l = { '<cmd>tabprevious<cr>', 'Go to previous tab' },
        g = { '<cmd>tabfirst<cr>', 'Go to first tab' },
        G = { '<cmd>tablast<cr>', 'Go to last tab' },
        n = { '<cmd>tabnew<cr>', 'New tab' },
      },
    }
  end,
}

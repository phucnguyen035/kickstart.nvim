return {
  'folke/which-key.nvim',
  cond = not vim.g.vscode,
  event = 'VeryLazy',
  opts = {
    spec = {
      { '<leader>q', group = 'quit' },
      { '<leader>c', group = 'code/copilot' },
      { '<leader>cc', group = 'chat', icon = ' ' },
      { '<leader>ct', group = 'toggle' },
      { '<leader>f', group = 'file' },
      { '<leader>s', group = 'search' },
      { '<leader>g', group = 'git' },
      { '<leader>b', group = 'buffer' },
      { '<leader>x', group = 'trouble' },
      { '<leader>t', group = 'tab' },
      { '<leader>w', group = 'workspace' },
      { '<leader>cf', '<cmd>Format<cr>', desc = 'Format code', mode = { 'n', 'v' } },
      { '<leader>ctf', '<cmd>FormatToggle<cr>', desc = 'Toggle format (global)' },
      { '<leader>ctF', '<cmd>FormatToggle!<cr>', desc = 'Toggle format (buffer)' },
      { '<leader>bb', '<cmd>b#<cr>', desc = 'Switch to last buffer' },
      { '<leader>bc', '<cmd>WipeWindowlessBufs<cr>', desc = 'Clear all buffers, keep current', silent = true },
      { '<leader>tg', '<cmd>tabfirst<cr>', desc = 'Go to first tab' },
      { '<leader>tG', '<cmd>tablast<cr>', desc = 'Go to last tab' },
      { '<leader>tn', '<cmd>tabnew<cr>', desc = 'New tab' },
      { '<leader>tx', '<cmd>tabclose<cr>', desc = 'Remove tab' },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}

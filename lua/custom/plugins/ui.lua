return {
  {
    'catppuccin/nvim',
    cond = not vim.g.vscode,
    name = 'catppuccin',
    priority = 1000,
    init = function()
      require('catppuccin').setup {
        color_overrides = {
          -- mocha = {
          --   base = '#000000',
          --   mantle = '#000000',
          --   crust = '#000000',
          -- },
        },
        integrations = {
          harpoon = true,
          mini = true,
          lsp_trouble = true,
          treesitter = true,
          gitsigns = true,
          telescope = true,
          cmp = true,
          which_key = true,
          ufo = true,
          navic = {
            enabled = true,
          },
        },
      }

      vim.cmd 'colorscheme catppuccin'
    end,
  },
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    opts = {
      select = {
        telescope = require('telescope.themes').get_cursor(),
      },
    },
  },
  {
    'nmac427/guess-indent.nvim',
    event = 'BufReadPre',
    opts = {},
  },
}
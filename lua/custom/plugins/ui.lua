return {
  {
    'catppuccin/nvim',
    cond = not vim.g.vscode,
    name = 'catppuccin',
    priority = 1000,
    init = function()
      require('catppuccin').setup {
        transparent_background = true,
        dim_inactive = {
          enabled = true,
          shade = 'dark',
          percentage = 0.15,
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
        },
      }

      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'stevearc/dressing.nvim',
    cond = not vim.g.vscode,
    event = 'VeryLazy',
    opts = {},
  },
  {
    'nmac427/guess-indent.nvim',
    event = 'BufReadPre',
    opts = {},
  },
}

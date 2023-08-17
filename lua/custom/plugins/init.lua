-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'ThePrimeagen/harpoon',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = {
      { '<leader>ha', "<cmd>:lua require('harpoon.mark').add_file()<cr>", desc = '[H]arpoon [A]dd' },
      { '<leader>hm', "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = '[H]arpoon [M]enu' },
      { '<leader>hn', "<cmd>:lua require('harpoon.ui').nav_next()<cr>", desc = '[H]arpoon [N]ext' },
      { '<leader>hp', "<cmd>:lua require('harpoon.ui').nav_prev()<cr>", desc = '[H]arpoon [P]revious' },
    },
  },
  {
    'mhartington/formatter.nvim',
    event = 'BufReadPre',
    opts = function()
      return {
        filetype = {
          lua = {
            require('formatter.filetypes.lua').stylua,
          },
          typescriptreact = {
            require 'formatter.defaults.prettierd',
          },
          typescript = {
            require 'formatter.defaults.prettierd',
          },
          javascript = {
            require 'formatter.defaults.prettierd',
          },
          javascriptreact = {
            require 'formatter.defaults.prettierd',
          },
          ['*'] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require('formatter.filetypes.any').remove_trailing_whitespace,
          },
        },
      }
    end,
  },
  {
    'ray-x/go.nvim',
    version = false,
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup { gofmt = 'gofumpt', lsp_gofumpt = true }
    end,
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()',
  },
}

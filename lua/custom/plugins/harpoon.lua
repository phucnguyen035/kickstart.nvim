return {
  'ThePrimeagen/harpoon',
  cond = not vim.g.vscode,
  branch = 'harpoon2',
  dependencies = 'nvim-lua/plenary.nvim',
  config = true,
  keys = {
    {
      '<leader>ha',
      '<cmd>lua require("harpoon"):list():add()<cr>',
      desc = 'Harpoon add',
    },
    {
      '<leader>hm',
      '<cmd>lua require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())<cr>',
      desc = 'Open Harpoon menu',
    },
    {
      '<leader>hp',
      '<cmd>lua require("harpoon"):list():prev()<cr>',
      desc = 'Harpoon previous item',
    },
    {
      '<leader>hn',
      '<cmd>lua require("harpoon"):list():next()<cr>',
      desc = 'Harpoon next item',
    },
  },
}

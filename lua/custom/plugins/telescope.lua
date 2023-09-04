-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  cond = not vim.g.vscode,
  cmd = 'Telescope',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  opts = {
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    defaults = {
      path_display = { 'smart' },
      layout_strategy = 'flex',
      mappings = {
        i = {
          ['<esc>'] = 'close',
        },
        n = {
          ['jk'] = 'close',
        },
      },
    },
  },
  config = function(_, opts)
    local telescope = require 'telescope'
    telescope.setup(opts)
    telescope.load_extension 'fzf'
    telescope.load_extension 'harpoon'
  end,
  keys = {
    {
      '<leader>?',
      function()
        require('telescope.builtin').oldfiles()
      end,
      desc = 'Find recently opened files',
    },
    {
      '<leader><space>',
      function()
        require('telescope.builtin').buffers()
      end,
      desc = 'Find existing buffers',
    },
    {
      '<leader>ff',
      function()
        require('telescope.builtin').find_files()
      end,
      desc = '[F]ind [F]iles',
    },
    {
      '<leader>fg',
      function()
        require('telescope.builtin').git_files()
      end,
      desc = '[F]ind [G]it files',
    },
    {
      '<leader>sh',
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sg',
      function()
        require('telescope.builtin').live_grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sw',
      function()
        require('telescope.builtin').grep_string()
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>sd',
      function()
        require('telescope.builtin').diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        require('telescope.builtin').resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>sb',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find { skip_empty_lines = true, previewer = false }
      end,
      desc = '[S]earch [B]uffer',
    },
  },
}

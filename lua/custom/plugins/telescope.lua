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
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
    },
  },
  config = function(_, opts)
    local telescope = require 'telescope'
    telescope.setup(opts)
    telescope.load_extension 'fzf'
  end,
  keys = {
    {
      '<leader>?',
      function()
        require('telescope.builtin').oldfiles { cwd_only = true }
      end,
      desc = 'Find recently opened files',
    },
    {
      '<leader><space>',
      function()
        require('telescope.builtin').buffers()
      end,
      desc = 'Find buffers',
    },
    {
      '<leader>ff',
      function()
        local function is_git_repo()
          vim.fn.system 'git rev-parse --is-inside-work-tree'
          return vim.v.shell_error == 0
        end
        local function get_git_root()
          local dot_git_path = vim.fn.finddir('.git', '.;')
          return vim.fn.fnamemodify(dot_git_path, ':h')
        end
        local opts = {}
        if is_git_repo() then
          opts = {
            cwd = get_git_root(),
          }
        end

        require('telescope.builtin').find_files(opts)
      end,
      desc = 'Find files from project root',
    },
    {
      '<leader>fg',
      function()
        require('telescope.builtin').git_files()
      end,
      desc = 'Find git files',
    },
    {
      '<leader>sh',
      function()
        require('telescope.builtin').help_tags()
      end,
      desc = 'Search help',
    },
    {
      '<leader>sg',
      function()
        require('telescope.builtin').live_grep()
      end,
      desc = 'Search grep',
    },
    {
      '<leader>sw',
      function()
        require('telescope.builtin').grep_string()
      end,
      desc = 'Search current word',
    },
    {
      '<leader>sc',
      function()
        require('telescope.builtin').resume()
      end,
      desc = 'Continue search',
    },
    {
      '<leader>sb',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find { skip_empty_lines = true, previewer = false }
      end,
      desc = 'Fuzzy search current buffer',
    },
    {
      '<leader>gb',
      function()
        require('telescope.builtin').git_branches()
      end,
      desc = 'Find git branches',
    },
  },
}

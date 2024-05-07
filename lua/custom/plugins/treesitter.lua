return {
  {
    -- Syntax highlighting
    'nvim-treesitter/nvim-treesitter',
    event = 'BufRead',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'lukas-reineke/indent-blankline.nvim',
      'windwp/nvim-ts-autotag',
    },
    build = ':TSUpdate',
    config = function()
      local highlight = {
        'CursorColumn',
        'Whitespace',
      }

      local ibl = require 'ibl'
      ibl.setup {
        indent = { highlight = highlight, char = '' },
        whitespace = {
          highlight = highlight,
          remove_blankline_trail = false,
        },
        scope = { enabled = false },
      }

      local function map(opts)
        return { query = opts.query, desc = 'TS: ' .. opts.desc }
      end

      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
      require('nvim-treesitter.configs').setup {
        autotag = {
          enable = true,
          enable_rename = true,
          enable_close = true,
          enable_close_on_slash = true,
        },

        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = {
          -- My stack
          'astro',
          'tsx',
          'typescript',
          'javascript',
          'svelte',
          'vue',
          -- Elixir stuff
          'elixir',
          'heex',
          -- Go
          'go',
          'templ',
          -- Misc
          'lua',
          'python',
          'rust',
          'vimdoc',
          'vim',
        },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,

        highlight = { enable = not vim.g.vscode },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            include_surrounding_whitespace = true,
            keymaps = {
              ['aa'] = map { query = '@parameter.outer', desc = 'Select outer function parameter' },
              ['ia'] = map { query = '@parameter.inner', desc = 'Select inner function parameter' },
              ['af'] = map { query = '@function.outer', desc = 'Select outer function' },
              ['if'] = map { query = '@function.inner', desc = 'Select inner function' },
              ['ac'] = map { query = '@class.outer', desc = 'Select outer class' },
              ['ic'] = map { query = '@class.inner', desc = 'Select inner class' },
            },
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = map { query = '@parameter.inner', desc = 'Swap with next parameter' },
            },
            swap_previous = {
              ['<leader>A'] = map { query = '@parameter.inner', desc = 'Swap with previous parameter' },
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = { query = '@function.outer', desc = 'Next function start' },
              [']]'] = { query = '@class.outer', desc = 'Next class start' },
            },
            goto_next_end = {
              [']M'] = { query = '@function.outer', desc = 'Next function end' },
              [']['] = { query = '@class.outer', desc = 'Next class end' },
            },
            goto_previous_start = {
              ['[m'] = { query = '@function.outer', desc = 'Previous function start' },
              ['[['] = { query = '@class.outer', desc = 'Previous class start' },
            },
            goto_previous_end = {
              ['[M'] = { query = '@function.outer', desc = 'Previous function end' },
              ['[]'] = { query = '@class.outer', desc = 'Previous class end' },
            },
          },
          lsp_interop = {
            enable = true,
            floating_preview_opts = {
              border = 'rounded',
            },
            peek_definition_code = {
              ['<leader>cp'] = map { query = '@function.outer', desc = 'Peek definition of function' },
              ['<leader>cP'] = map { query = '@class.outer', desc = 'Peek definition of class' },
            },
          },
        },
      }
    end,
  },
  {
    -- Display the current context of thhe visible buffer contents
    'nvim-treesitter/nvim-treesitter-context',
    cond = not vim.g.vscode,
    event = 'BufRead',
    opts = function()
      local ts_context = require 'treesitter-context'

      vim.keymap.set('n', '[c', function()
        ts_context.go_to_context()
      end, { silent = true, desc = 'Jump to context' })

      return {
        max_lines = 3,
        separator = '_',
      }
    end,
  },
  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    event = 'BufRead',
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
}

return {
  {
    'ThePrimeagen/harpoon',
    cond = not vim.g.vscode,
    dependencies = 'nvim-lua/plenary.nvim',
    opts = {},
    keys = {
      { '<leader>hm', "<cmd>:lua require('harpoon.mark').add_file()<cr>", desc = '[H]arpoon [M]ark' },
      { '<leader>ho', "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = '[H]arpoon [O]pen menu' },
      { '<leader>hn', "<cmd>:lua require('harpoon.ui').nav_next()<cr>", desc = '[H]arpoon [N]ext' },
      { '<leader>hp', "<cmd>:lua require('harpoon.ui').nav_prev()<cr>", desc = '[H]arpoon [P]revious' },
    },
  },
  -- Linter
  {
    'mfussenegger/nvim-lint',
    cond = not vim.g.vscode,
    event = 'BufRead',
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        yaml = { 'actionlint' },
        python = { 'ruff' },
        go = { 'golangcilint' },
      }

      vim.api.nvim_create_autocmd('BufWritePost', {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  -- Formatter
  {
    'stevearc/conform.nvim',
    cond = not vim.g.vscode,
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'ConformInfo' },
    config = function(_, opts)
      local conform = require 'conform'
      conform.setup(opts)

      vim.api.nvim_create_user_command('Format', function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ['end'] = { args.line2, end_line:len() },
          }
        end
        conform.format { async = true, lsp_fallback = true, range = range }
      end, { range = true })

      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true,
      })
      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Re-enable autoformat-on-save',
      })
    end,
    opts = function()
      local slow_format_filetypes = { 'typescriptreact' }

      return {
        notify_on_error = false,
        formatters_by_ft = {
          lua = { 'stylua' },
          javascript = { 'prettierd' },
          javascriptreact = { 'prettierd' },
          typescript = { 'prettierd' },
          typescriptreact = { 'prettierd' },
          css = { 'prettierd' },
          astro = { 'prettierd' },
          html = { 'prettierd' },
          python = { 'isort', 'blackd' },
          go = { 'gofumpt', 'goimports', 'golines' },
          gohtmltmpl = { 'prettierd' },
          json = { 'jq', 'prettierd' },
        },
        format_on_save = function(bufnr)
          if slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end

          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          local function on_format(err)
            if err and err:match 'timeout$' then
              slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
          end

          return { timeout_ms = 500, lsp_fallback = true }, on_format
        end,
        format_after_save = function(bufnr)
          if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          return { lsp_fallback = true }
        end,
        formatters = {
          blackd = {
            command = 'blackd-client',
          },
        },
      }
    end,
  },
  -- Diagnostics
  {
    'folke/trouble.nvim',
    cond = not vim.g.vscode,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>TroubleToggle<cr>', desc = 'Trouble' },
      { '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Trouble Document' },
      { '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Trouble Workspace' },
      { '<leader>xl', '<cmd>TroubleToggle loclist<cr>', desc = 'Trouble Location' },
      { '<leader>xq', '<cmd>TroubleToggle quickfix<cr>', desc = 'Trouble Quickfix' },
      { '<leader>xr', '<cmd>TroubleRefresh<cr>', desc = 'Trouble Refresh' },
    },
  },
  -- Free alternative to Copilot
  -- {
  --   'Exafunction/codeium.vim',
  --   cond = not vim.g.vscode,
  --   event = 'BufEnter',
  --   cmd = 'Codeium',
  -- },
  {
    'zbirenbaum/copilot.lua',
    cond = not vim.g.vscode,
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        auto_trigger = true,
      },
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    opts = {},
  },
  -- Zen Mode
  {
    'folke/zen-mode.nvim',
    cond = not vim.g.vscode,
    dependencies = { 'folke/twilight.nvim' },
    cmd = 'ZenMode',
    opts = {
      window = {
        backdrop = 1,
        width = 150,
      },
      plugins = {
        twilight = { enabled = true },
        tmux = { enabled = true },
        wezterm = { enabled = true, font = 15 },
      },
    },
    keys = {
      { 'gz', '<cmd>ZenMode<cr>', desc = '[G]o [Z]en Mode', silent = true },
    },
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    opts = {
      override = {
        postcss = {
          icon = '',
          color = '#5293CB',
          name = 'PostCSS',
        },
      },
    },
  },
}

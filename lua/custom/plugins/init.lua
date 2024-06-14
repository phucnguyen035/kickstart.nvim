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
        go = { 'golangcilint' },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
        group = vim.api.nvim_create_augroup('lint', { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set('n', '<leader>cl', function()
        lint.try_lint()
      end, { desc = 'Trigger [C]ode [L]inting for current file' })
    end,
  },
  -- Formatter
  {
    'stevearc/conform.nvim',
    cond = not vim.g.vscode,
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo', 'Format', 'FormatToggle', 'FormatStatus' },
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

      vim.api.nvim_create_user_command('FormatToggle', function(args)
        if args.bang then
          local current = vim.b.disable_autoformat
          local next = not current
          -- FormatToggle! will disable formatting just for this buffer
          vim.b.disable_autoformat = next
          print('Autoformat ' .. (next and 'disabled' or 'enabled') .. ' for this buffer')
        else
          local current = vim.g.disable_autoformat
          local next = not current
          vim.g.disable_autoformat = next
          print('Autoformat ' .. (next and 'disabled' or 'enabled') .. ' globally')
        end
      end, {
        desc = 'Toggle autoformat-on-save',
        bang = true,
      })

      vim.api.nvim_create_user_command('FormatStatus', function()
        if vim.b.disable_autoformat == true then
          print 'Autoformat is disabled for this buffer'
        elseif vim.g.disable_autoformat == true then
          print 'Autoformat is disabled globally'
        else
          print 'Autoformat is enabled'
        end
      end, {
        desc = 'Show autoformat status',
      })
    end,
    opts = function()
      local slow_format_filetypes = {}

      return {
        notify_on_error = false,
        formatters_by_ft = {
          lua = { 'stylua' },
          astro = { { 'prettierd', 'biome' } },
          javascript = { { 'prettierd', 'biome' } },
          javascriptreact = { { 'prettierd', 'biome' } },
          typescript = { { 'prettierd', 'biome' } },
          typescriptreact = { { 'prettierd', 'biome' } },
          css = { { 'prettierd', 'biome' } },
          html = { { 'prettierd', 'biome' } },
          go = { 'gofumpt', 'goimports', 'golines' },
          json = { { 'jq', 'prettierd', 'biome' } },
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
  {
    'zbirenbaum/copilot.lua',
    cond = not vim.g.vscode,
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        auto_trigger = true,
      },
      filetypes = {
        yaml = true,
      },
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    event = 'BufRead',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    opts = {
      mappings = {
        reset = {
          normal = '<C-r>',
          insert = '<C-r>',
        },
      },
    },
    keys = {
      {
        '<leader>cco',
        function()
          require('CopilotChat').open()
        end,
        desc = 'CopilotChat - Open',
      },
      {
        '<leader>ccq',
        function()
          vim.ui.input({
            prompt = 'Quick Chat: ',
          }, function(input)
            if not input or input == '' then
              return
            end

            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end)
        end,
        desc = 'CopilotChat - Quick chat',
      },
      {
        '<leader>ccp',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        mode = { 'n', 'v', 'x' },
        desc = 'CopilotChat - Prompt actions',
      },
    },
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

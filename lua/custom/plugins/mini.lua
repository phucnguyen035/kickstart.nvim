return {
  {
    'echasnovski/mini.files',
    version = false,
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local mf = require 'mini.files'
      mf.setup {
        windows = {
          preview = true,
          width_preview = 80,
        },
      }
      local show_dotfiles = true
      local filter_show = function()
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, '.')
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        mf.refresh { content = { filter = new_filter } }
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id, desc = 'Toggle dotfiles visibility' })
        end,
      })

      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          -- Make new window and set it as target
          local new_target_window
          vim.api.nvim_win_call(mf.get_target_window(), function()
            vim.cmd(direction .. ' split')
            new_target_window = vim.api.nvim_get_current_win()
          end)

          MiniFiles.set_target_window(new_target_window)
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = 'Split ' .. direction
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak keys to your liking
          map_split(buf_id, 'gs', 'belowright horizontal')
          map_split(buf_id, 'gv', 'belowright vertical')
        end,
      })
    end,
    keys = {
      {
        '<leader>fd',
        function()
          require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = 'Open [F]iles in current [D]irectory',
      },
      {
        '<leader>fr',
        function()
          require('mini.files').open(vim.loop.cwd(), true)
        end,
        desc = 'Open [F]iles in [R]oot diretory (cwd)',
      },
    },
  },
  { 'echasnovski/mini.pairs', version = false, event = 'InsertEnter', opts = {} },
  { 'echasnovski/mini.starter', version = false, lazy = false, opts = {} },
}

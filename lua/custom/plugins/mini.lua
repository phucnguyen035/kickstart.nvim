local section_name = "Actions"
local actions = {
  { name = 'Find files',   action = 'Telescope find_files',    section = section_name },
  { name = 'Recent files', action = "Telescope oldfiles",      section = section_name },
  { name = 'Grep text',    action = 'Telescope live_grep',     section = section_name },
  { name = 'Marks',        action = "Telescope harpoon marks", section = section_name },
  { name = "Quit Neovim",  action = "q",                       section = section_name },
}

return {
  {
    'echasnovski/mini.files',
    cond = not vim.g.vscode,
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
          local mf = require('mini.files')
          local path = vim.api.nvim_buf_get_name(0)
          -- Get latest path if path ends with /Starter
          if path:sub(-8) == '/Starter' then
            path = mf.get_latest_path()
          end
          print(path)

          mf.open(path)
        end,
        desc = 'Open [F]iles in current [D]irectory',
        silent = true
      },
      {
        '<leader>fr',
        function()
          require('mini.files').open(nil, false)
        end,
        desc = 'Open [F]iles in [R]oot diretory (cwd)',
      },
    },
  },
  { 'echasnovski/mini.pairs',       version = false,   cond = not vim.g.vscode, event = 'InsertEnter', opts = {} },
  { 'echasnovski/mini.indentscope', version = false,   event = "BufReadPre",    opts = {} },
  { 'echasnovski/mini.bufremove',   version = false,   event = "BufRead",       opts = {} },
  { 'echasnovski/mini.cursorword',  event = "BufRead", version = false,         opts = {} },
  {
    'echasnovski/mini.sessions',
    version = false,
    event = 'VimEnter',
    opts = {},
    keys = {
      { '<leader>mss', function() require('mini.sessions').select() end, desc = '[S]elect [S]ession' }
    }
  },
  {
    'echasnovski/mini.surround',
    version = false,
    event = { 'BufNewFile', 'BufRead' },
    opts = {
      mappings = {
        add = 'gsa',            -- Add surrounding in Normal and Visual modes
        delete = 'gsd',         -- Delete surrounding
        find = 'gsf',           -- Find surrounding (to the right)
        find_left = 'gsF',      -- Find surrounding (to the left)
        highlight = 'gsh',      -- Highlight surrounding
        replace = 'gsr',        -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
      },
    },
  },
  {
    'echasnovski/mini.starter',
    version = false,
    cond = not vim.g.vscode,
    event = 'VimEnter',
    opts = function()
      local starter = require 'mini.starter'
      return {
        header = [[
         _____  ___    _______    ______  ___      ___  __     ___      ___
        (\"   \|"  \  /"     "|  /    " \|"  \    /"  ||" \   |"  \    /"  |
        |.\\   \    |(: ______) // ____  \\   \  //  / ||  |   \   \  //   |
        |: \.   \\  | \/    |  /  /    ) :)\\  \/. ./  |:  |   /\\  \/.    |
        |.  \    \. | // ___)_(: (____/ //  \.    //   |.  |  |: \.        |
        |    \    \ |(:      "|\        /    \\   /    /\  |\ |.  \    /:  |
         \___|\____\) \_______) \"_____/      \__/    (__\_|_)|___|\__/|___|
        ]],
        evaluate_single = true,
        items = {
          actions,
          starter.sections.sessions(3, true),
          starter.sections.recent_files(9, true),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.indexing('all', { 'Sessions', section_name }),
          starter.gen_hook.padding(3, 2),
          starter.gen_hook.aligning('center', 'center'),
        },
        footer = '',
      }
    end,
  },
}

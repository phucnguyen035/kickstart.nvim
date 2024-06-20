return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons', 'AndreM222/copilot-lualine' },
    -- See `:help lualine.txt`
    opts = {
      options = {
        theme = 'auto',
        component_separators = '',
        section_separators = { left = '', right = '' },
        disabled_filetypes = { 'dashboard', 'alpha', 'starter' },
      },
      extensions = {
        'quickfix',
        'lazy',
      },
      sections = {
        lualine_a = {
          'branch',
        },

        lualine_b = {
          'diagnostics',
        },

        lualine_c = {
          'diff',
          '%=',
          { 'filename', path = 1, shorting_target = 10 },
        },

        lualine_x = { 'copilot' },
        lualine_y = { 'filetype', 'progress' },
        lualine_z = {
          { 'location', separator = { right = '' }, left_padding = 2 },
        },
      },
    },
  },
}

local mode_map = {
  ['n'] = 'N',
  ['no'] = 'O·P',
  ['nov'] = 'O·P',
  ['noV'] = 'O·P',
  ['no\22'] = 'O·P',
  ['niI'] = 'N·I',
  ['niR'] = 'N·R',
  ['niV'] = 'N',
  ['nt'] = 'N·T',
  ['v'] = 'V',
  ['vs'] = 'V',
  ['V'] = 'V·L',
  ['Vs'] = 'V·L',
  ['\22'] = 'V·B',
  ['\22s'] = 'V·B',
  ['s'] = 'S',
  ['S'] = 'S·L',
  ['\19'] = 'S·B',
  ['i'] = 'I',
  ['ic'] = 'I·C',
  ['ix'] = 'I·X',
  ['R'] = 'R',
  ['Rc'] = 'R·C',
  ['Rx'] = 'R·X',
  ['Rv'] = 'V·R',
  ['Rvc'] = 'RVC',
  ['Rvx'] = 'RVX',
  ['c'] = 'C',
  ['cv'] = 'EX',
  ['ce'] = 'EX',
  ['r'] = 'R',
  ['rm'] = 'M',
  ['r?'] = 'C',
  ['!'] = 'SH',
  ['t'] = 'T',
}

return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = 'nvim-tree/nvim-web-devicons',
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
          { 'mode', separator = { left = '' }, right_padding = 10 },
        },

        lualine_b = {
          { 'filename', path = 0 },
          'branch',
        },

        lualine_c = {
          { 'diff', colored = true, symbols = { added = ' ', modified = ' ', removed = ' ' } },
          'diagnostics',
        },

        lualine_x = { 'copilot' },
        lualine_y = { 'filetype', 'progress' },
        lualine_z = {
          { 'location', separator = { right = '' }, left_padding = 2 },
        },
      },
    },
  },
  {
    'AndreM222/copilot-lualine',
    event = 'BufRead',
  },
}

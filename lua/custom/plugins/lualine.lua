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
    event = 'BufRead',
    dependencies = 'nvim-tree/nvim-web-devicons',
    -- See `:help lualine.txt`
    opts = {
      options = {
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
        disabled_filetypes = { 'dashboard', 'alpha', 'starter' },
      },
      extensions = {
        'quickfix',
        'lazy',
      },
      sections = {
        lualine_a = {
          function()
            return mode_map[vim.api.nvim_get_mode().mode] or '__'
          end,
        },
        lualine_x = { 'copilot', 'encoding', 'filetype' },
      },
    },
  },
  {
    'AndreM222/copilot-lualine',
    event = 'BufRead',
  },
}

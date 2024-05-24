return {
  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      local nvim_tmux_nav = require 'nvim-tmux-navigation'

      nvim_tmux_nav.setup {
        disable_when_zoomed = true, -- defaults to false
      }

      local nmap = function(key, cmd)
        vim.keymap.set('n', key, cmd)
      end

      nmap('<C-h>', nvim_tmux_nav.NvimTmuxNavigateLeft)
      nmap('<C-j>', nvim_tmux_nav.NvimTmuxNavigateDown)
      nmap('<C-k>', nvim_tmux_nav.NvimTmuxNavigateUp)
      nmap('<C-l>', nvim_tmux_nav.NvimTmuxNavigateRight)
      nmap('<C-\\>', nvim_tmux_nav.NvimTmuxNavigateLastActive)
      nmap('<C-Space>', nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
}

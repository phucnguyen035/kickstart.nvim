if vim.g.vscode then
  return {}
end

return {
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map('n', ']h', gs.next_hunk, 'Next Hunk')
        map('n', '[h', gs.prev_hunk, 'Previous Hunk')
        map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<cr>', 'Stage Hunk')
        map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<cr>', 'Reset Hunk')
        map('n', '<leader>ghS', gs.stage_buffer, 'Stage Buffer')
        map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
        map('n', '<leader>ghR', gs.reset_buffer, 'Reset Buffer')
        map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview Hunk Inline')
        map({ 'n', 'v' }, '<leader>ghb', function()
          gs.blame_line { full = true }
        end, 'Blame Line')
        map('n', '<leader>ghd', gs.diffthis, 'Diff This')
        map('n', '<leader>ghD', function()
          gs.diffthis '~'
        end, 'Diff This ~')
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
      end,
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
    },
    keys = {
      { '<leader>gs', ':Neogit<cr>', noremap = true, silent = true, desc = 'Neogit' },
      { '<leader>gc', ':Neogit commit<cr>', desc = 'Git commit' },
      { '<leader>gP', ':Neogit push<cr>', desc = 'Git push' },
      { '<leader>gp', ':Neogit pull<cr>', desc = 'Git pull' },
      { '<leader>gf', ':Neogit fetch<cr>', desc = 'Git fetch', noremap = true, silent = true },
      { '<leader>gr', ':Neogit rebase<cr>', desc = 'Git rebase' },
      { '<leader>gm', ':Neogit merge<cr>', desc = 'Git merge' },
      { '<leader>gZ', ':Neogit stash<cr>', desc = 'Git stash' },
      { '<leader>gd', ':Neogit diff<cr>', desc = 'Git diff' },
    },
    opts = {},
  },
}

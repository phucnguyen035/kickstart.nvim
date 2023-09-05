return {
	{
		'kdheepak/lazygit.nvim',
		cond = not vim.g.vscode,
		dependencies = { 'nvim-lua/plenary.nvim' },
		keys = {
			{ '<leader>gg', '<cmd>LazyGit<cr>', noremap = true, silent = true, desc = 'Open LazyGit' },
		},
	},
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		cond = not vim.g.vscode,
		event = { 'BufReadPre', 'BufNewFile' },
		opts = {
			-- See `:help gitsigns.txt`
			current_line_blame = true,
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function(bufnr)
				vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
					{ buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
				vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
					{ buffer = bufnr, desc = '[G]it go to [N]ext hunk' })
				vim.keymap.set('n', '<leader>gp', require('gitsigns').preview_hunk,
					{ buffer = bufnr, desc = '[G]it [P]review hunk' })
				vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line, { buffer = bufnr, desc = '[G]it [B]lame' })
			end,
		},
	}
}

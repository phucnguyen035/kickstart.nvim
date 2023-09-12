return {
	'kevinhwang91/nvim-ufo',
	dependencies = 'kevinhwang91/promise-async',
	event = "BufRead",
	opts = {
		close_fold_kinds = { 'imports', 'comment' },
	},
	keys = {
		{ 'zr', '<cmd>lua require("ufo").openFoldsExceptKinds()<cr>', desc = 'Open Folds Except Kinds' },
		{ 'zR', '<cmd>lua require("ufo").openAllFolds()<cr>', },
		{ 'zM', '<cmd>lua require("ufo").closeFoldsWith()<cr>',       desc = "yikes" },
		{ 'zM', '<cmd>lua require("ufo").closeAllFolds()<cr>', },
		{
			'K',
			function()
				local winid = require('ufo').peekFoldedLinesUnderCursor()
				if not winid then
					-- choose one of coc.nvim and nvim lsp
					vim.fn.CocActionAsync('definitionHover') -- coc.nvim
					vim.lsp.buf.hover({})
				end
			end,
			desc = 'Hover'
		},
	},
}

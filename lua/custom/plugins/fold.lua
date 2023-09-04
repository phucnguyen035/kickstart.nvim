return {
	'kevinhwang91/nvim-ufo',
	dependencies = 'kevinhwang91/promise-async',
	event = "BufRead",
	opts = {
		close_fold_kinds = { 'imports', 'comment' },
		fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
			local newVirtText = {}
			local suffix = (' 󰁂 %d '):format(endLnum - lnum)
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0
			for _, chunk in ipairs(virtText) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					local hlGroup = chunk[2]
					table.insert(newVirtText, { chunkText, hlGroup })
					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					-- str width returned from truncate() may less than 2nd argument, need padding
					if curWidth + chunkWidth < targetWidth then
						suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
					end
					break
				end
				curWidth = curWidth + chunkWidth
			end
			table.insert(newVirtText, { suffix, 'MoreMsg' })
			return newVirtText
		end
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
					vim.lsp.buf.hover()
				end
			end,
			desc = 'Hover'
		},
	},
}

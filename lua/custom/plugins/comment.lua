return {
	'numToStr/Comment.nvim',
	cond = not vim.g.vscode,
	event = 'BufReadPost',
	opts = {}
}

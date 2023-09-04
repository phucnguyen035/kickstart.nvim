vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'go', 'rust', 'python' },
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
	end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
	pattern = { '*.ts', '*.tsx', '*.js', '*.jsx', '*.astro' },
	command = 'FormatWrite',
})

-- Run gofmt + goimport on save
local format_sync_grp = vim.api.nvim_create_augroup('GoFmt', {})
vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = '*.go',
	callback = function()
		require('go.format').gofmt()
		require('go.format').org_imports()
	end,
	group = format_sync_grp,
})

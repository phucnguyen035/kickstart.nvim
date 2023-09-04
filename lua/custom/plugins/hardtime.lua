return {
	"m4xshen/hardtime.nvim",
	event = "BufReadPost",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	opts = {
		disabled_filetypes = { 'Starter', 'minifiles' },
		max_count = 10
	}
}

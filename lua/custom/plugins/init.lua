-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
if vim.g.vscode then
	return {}
end

return {
	{
		'ThePrimeagen/harpoon',
		dependencies = 'nvim-lua/plenary.nvim',
		opts = {},
		keys = {
			{ '<leader>ha', "<cmd>:lua require('harpoon.mark').add_file()<cr>",        desc = '[H]arpoon [A]dd' },
			{ '<leader>hm', "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = '[H]arpoon [M]enu' },
			{ '<leader>hn', "<cmd>:lua require('harpoon.ui').nav_next()<cr>",          desc = '[H]arpoon [N]ext' },
			{ '<leader>hp', "<cmd>:lua require('harpoon.ui').nav_prev()<cr>",          desc = '[H]arpoon [P]revious' },
		},
	},
	{
		'mhartington/formatter.nvim',
		event = 'BufReadPost',
		opts = function()
			local defaults = require 'formatter.defaults'
			return {
				filetype = {
					typescriptreact = {
						defaults.prettierd,
					},
					typescript = {
						defaults.prettierd,
					},
					javascript = {
						defaults.prettierd,
					},
					javascriptreact = {
						defaults.prettierd,
					},
					astro = {
						defaults.prettierd,
					},
				},
			}
		end,
	},
	{
		'ray-x/go.nvim',
		dependencies = {
			'ray-x/guihua.lua',
			'neovim/nvim-lspconfig',
			'nvim-treesitter/nvim-treesitter',
		},
		opts = {
			lsp_gofumpt = true,
		},
		ft = { 'go', 'gomod' },
		build = ':lua require("go.install").update_all_sync()',
	},
	-- Free alternative to Copilot
	{
		'Exafunction/codeium.vim',
		event = 'BufEnter',
		cmd = 'Codeium',
	},
	-- Diagnostics
	{
		'folke/trouble.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {},
		keys = {
			{ '<leader>xx', '<cmd>TroubleToggle<cr>',                       desc = 'Trouble' },
			{ '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>',  desc = 'Trouble Document' },
			{ '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Trouble Workspace' },
			{ '<leader>xl', '<cmd>TroubleToggle loclist<cr>',               desc = 'Trouble Location' },
			{ '<leader>xq', '<cmd>TroubleToggle quickfix<cr>',              desc = 'Trouble Quickfix' },
			{ '<leader>xr', '<cmd>TroubleRefresh<cr>',                      desc = 'Trouble Refresh' },
		},
	},
	-- Zen Mode
	{
		'folke/zen-mode.nvim',
		cmd = 'ZenMode',
		opts = {
			plugins = {
				tmux = {
					enabled = true,
				},
				wezterm = {
					enabled = true,
				},
			},
		},
	},
	{
		"rgroli/other.nvim",
		cmd = { "Other", "OtherClear", "OtherSplit", "OtherVSplit" },
		keys = {
			{ "<leader><TAB>", "<cmd>Other<CR>", desc = "Other", silent = true },
		},
		config = function()
			local sveltekit_target = {
				{ target = "src/routes%1/%+layout.svelte",    context = "layout-view" },
				{ target = "src/routes%1/%+layout.ts",        context = "layout-load" },
				{ target = "src/routes%1/%+layout.server.ts", context = "layout-load-server" },
				{ target = "src/routes%1/%+page.svelte",      context = "page-view" },
				{ target = "src/routes%1/%+page.ts",          context = "page-load" },
				{ target = "src/routes%1/%+page.server.ts",   context = "page-load-server" },
				{ target = "src/routes%1/%+error.svelte",     context = "error" },
			}

			local nextjs_target = {
				{ target = "app%1/page.tsx",    context = "page" },
				{ target = "app%1/loading.tsx", context = "loading" },
				{ target = "app%1/error.tsx",   context = "error" },
				{ target = "app%1/layout.tsx",  context = "layout" },
				{ target = "app%1/route.ts",    context = "route" },
			}
			require("other-nvim").setup(
				{
					rememberBuffers = false,
					mappings = {
						-- builtin mappings
						'golang',
						-- sveltekit
						{ pattern = "src/routes(.*)/%+(.*).ts$",     target = sveltekit_target, },
						{ pattern = "src/routes(.*)/+(.*)%.svelte$", target = sveltekit_target, },
						-- nextjs app router
						{ pattern = "app(.*)/page.tsx",              target = nextjs_target },
						{ pattern = "app(.*)/loading.tsx",           target = nextjs_target },
						{ pattern = "app(.*)/error.tsx",             target = nextjs_target },
						{ pattern = "app(.*)/layout.tsx",            target = nextjs_target },
						{ pattern = "app(.*)/route.ts",              target = nextjs_target },
					},
					style = {
						width = 0.9
					}
				}
			)
		end,
	},
}

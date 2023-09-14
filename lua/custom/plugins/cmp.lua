return {
	{
		'L3MON4D3/LuaSnip',
		lazy = true,
		opts = {
			history = true,
			region_check_events = 'InsertEnter',
			delete_check_events = 'TextChanged,InsertLeave',
		},
	},
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
			'rafamadriz/friendly-snippets',
			'onsails/lspkind-nvim',
		},
		config = function()
			-- [[ Configure nvim-cmp ]]
			-- See `:help cmp`
			local cmp = require 'cmp'
			local lspkind = require 'lspkind'
			local luasnip = require 'luasnip'
			require('luasnip.loaders.from_vscode').lazy_load()

			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				preselect = cmp.PreselectMode.None,

				mapping = cmp.mapping.preset.insert {
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete {},
					['<CR>'] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					['<Tab>'] = cmp.mapping(function(fallback)
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				},

				formatting = {
					format = lspkind.cmp_format {
						mode = 'symbol_text',
						maxwidth = 50,
						ellipsis_char = '...',
						-- symbol_map = { Copilot = '' },
					},
				},

				sources = cmp.config.sources({
					-- { name = 'copilot' },
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'path' },
				}, {
					{ name = 'buffer' },
				}),

				sorting = {
					priority_weight = 2,
					comparators = {
						-- require('copilot_cmp.comparators').prioritize,
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						---@diagnostic disable-next-line: assign-type-mismatch
						cmp.config.compare.recently_used,
						---@diagnostic disable-next-line: assign-type-mismatch
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
			}
		end,
	},
}
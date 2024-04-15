if vim.g.vscode then
  return {}
end

local function filter(arr, fn)
  if type(arr) ~= 'table' then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local function filterReactDTS(value)
  return string.match(value.filename, '%.d.ts') == nil
end

local function on_list(options)
  -- https://github.com/typescript-language-server/typescript-language-server/issues/216
  local items = options.items
  if #items > 1 then
    items = filter(items, filterReactDTS)
  end

  vim.fn.setqflist({}, ' ', { title = options.title, items = items, context = options.context })
  vim.api.nvim_command 'cfirst'
end

return {
  {

    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',

      -- A simple popup display that provides breadcrumbs like navigation feature but in keyboard centric manner inspired by ranger file manager.
      {
        'SmiteshP/nvim-navbuddy',
        cond = not vim.g.vscode,
        dependencies = {
          'SmiteshP/nvim-navic',
          'MunifTanjim/nui.nvim',
        },
        opts = {
          lsp = { auto_attach = true },
          highlight = true,
        },
      },
    },
    config = function()
      require('lspconfig.ui.windows').default_options = {
        border = 'single',
      }
      -- [[ Configure LSP ]]
      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(client, bufnr)
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
        end

        nmap('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', function()
          vim.lsp.buf.definition { on_list = on_list }
        end, '[G]oto [D]efinition')
        nmap('gr', function()
          require('telescope.builtin').lsp_references { include_declaration = false }
        end, '[G]oto [R]eferences')
        nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = '[C]ode [A]ction' })

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('gs', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        if client.name == 'eslint' then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'EslintFixAll',
          })
        end

        -- Big hack for svelte https://www.reddit.com/r/neovim/comments/1598ewp/neovim_svelte/
        if client.name == 'svelte' then
          vim.api.nvim_create_autocmd('BufWritePost', {
            pattern = { '*.js', '*.ts' },
            callback = function(ctx)
              client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.file })
            end,
          })
        end
      end

      --  Add any additional override configuration in the following tables. They will be passed to
      --  the `settings` field of the server config. You must look up that documentation yourself.
      --
      --  If you want to override the default filetypes that your language server will attach to you can
      --  define the property 'filetypes' to the map in question.
      local servers = {
        -- clangd = {},
        gopls = {
          filetypes = { 'go', 'gomod', 'gowork', 'gotmpl', 'gohtmltmpl', 'gotexttmpl' },
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = false,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
            semanticTokens = true,
            ['build.templateExtensions'] = { 'gohtml', 'html', 'gotmpl', 'tmpl' },
          },
        },
        -- pyright = {},
        rust_analyzer = {},
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
        -- js stuff
        html = {},
        emmet_ls = { filetypes = { 'html', 'gohtmltmpl', 'typescriptreact', 'javascriptreact', 'svelte', 'vue', 'astro' } },
        cssls = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = 'ignore',
            },
          },
        },
        tsserver = {},
        prismals = {},
        astro = {},
        svelte = {},
        volar = {},
        tailwindcss = {},
        eslint = {},
      }

      -- Setup neovim lua configuration
      require('neodev').setup()

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.workspace.didChangeWatchedFiles = {
        dynamicRegistration = true,
        relativePatternSupport = true,
      }

      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          }
        end,
      }

      -- Whenever an LSP attaches to a buffer, we will run this function.
      -- See `:help LspAttach` for more information about this autocmd event.
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client_id = args.data.client_id
          local client = vim.lsp.get_client_by_id(client_id)

          -- Only attach to clients that support document formatting
          if not client.server_capabilities.documentFormattingProvider then
            return
          end

          -- Tsserver usually works poorly. Sorry you work with bad languages
          -- You can remove this line if you know what you're doing :)
          if client.name == 'tsserver' then
            return
          end

          -- Big hack for svelte https://www.reddit.com/r/neovim/comments/1598ewp/neovim_svelte/
          vim.api.nvim_create_autocmd({ 'BufWrite' }, {
            pattern = { '+page.server.ts', '+page.ts', '+layout.server.ts', '+layout.ts' },
            command = 'LspRestart svelte',
          })
        end,
      })
    end,
  },
  {
    'ray-x/go.nvim',
    cond = not vim.g.vscode,
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      lsp_document_formatting = false, -- Use conform for formatting
      trouble = true,
      luasnip = true,
    },
    ft = { 'go', 'gomod', 'gohtmltmpl' },
    build = ':lua require("go.install").update_all_sync()',
  },
}

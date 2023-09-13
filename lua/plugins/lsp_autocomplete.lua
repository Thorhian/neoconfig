-- LSP/AutoCompletion & DAP -------------------------------
local lsp_setup = function()
   vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
         update_in_insert = true,
      }
   )

   local os_type = vim.loop.os_uname().sysname
   local homeDir = os.getenv("HOME")
   local dataDir = vim.fn.stdpath("data")
   local masonPackageLoc = dataDir .. '/mason/packages'
   local omnisharp_loc = ""
   if os_type == "Windows_NT" then
      print("Config is loading on windows.")
      homeDir = os.getenv("UserProfile")

      omnisharp_loc = "\\Documents\\dev_tools\\omnisharp-win-x64\\OmniSharp.exe"
   end

   local on_attach = function(client, bufnr)
      -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      local bufopts = { silent=true, buffer=bufnr, prefix="<leader>" }

      local navbuddy = require("nvim-navbuddy")
      local navic = require("nvim-navic")
      navbuddy.attach(client, bufnr)

      if client.server_capabilities.documentSymbolProvider then
         navic.attach(client, bufnr)
      end

      local wk = require("which-key")
      wk.register({
         l = {
            name = "LSP: " .. client.name,
            D = { function() vim.lsp.buf.declaration({ reuse_win = true }) end, "Find Declaration" },
            d = { function() vim.lsp.buf.definition({ reuse_win = true }) end, "Find Definition" },
            k = { function() vim.lsp.buf.hover() end, "Show Hover Info" },
            i = { function() vim.lsp.buf.implementation() end, "Find Implementation" },
            c = { function() vim.lsp.buf.code_action() end, "Code Action(s)" },
            r = { function() vim.lsp.buf.references() end, "Find References" },
            R = { function() vim.lsp.buf.rename() end, "Rename Symbol" },
            f = { function() vim.lsp.buf.format() end, "Format Buffer" },
            I = { function() vim.lsp.buf.incoming_calls() end, "Incoming Calls" },
            O = { function() vim.lsp.buf.outgooing_calls() end, "Outgoing Calls" },
            l = {
               name = "Lenses",
               c = { function() vim.lsp.codelens.clear() end, "Clear Lens" },
               r = { function() vim.lsp.codelens.run() end, "Run Selected Lens" },
               R = { function() vim.lsp.codelens.refresh() end, "Refresh Lens" },
               d = { function() vim.lsp.codelens.display() end, "Display Lens" }
            }
         },
         n = {
            name = "Navigation",
            n = { function() navbuddy.open() end, "Navbuddy" },
         },
      }, bufopts)
   end

   local lsp_flags = {
      debounce_text_changes = 150,
   }

   local capabilities = vim.lsp.protocol.make_client_capabilities()
   capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

   require 'lspconfig'.pyright.setup{
      before_init = function(_, config)
         --local stub_path = _G.join_paths(
         --    _G.get_runtime_dir(),
         --    "site",
         --    "pack",
         --    "packer",
         --    "opt",
         --    "python-type-stubs"
         --)
         --print(stub_path)
         local stubs = vim.fn.stdpath("data") .. "/site/pack/packer/opt/python-type-stubs"
         config.settings.python.analysis.stubPath = stubs
      end,
      on_attach = on_attach,
      flags = lsp_flags,
   }

   require'lspconfig'.lua_ls.setup {
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
      settings = {
         Lua = {
            runtime = {
               -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
               version = 'LuaJIT',
            },
            diagnostics = {
               -- Get the language server to recognize the `vim` global
               globals = {'vim'},
            },
            workspace = {
               -- Make the server aware of Neovim runtime files
               library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
               enable = false,
            },
         },
      },
   }

   -- Configure Elixir LS
   local els_unexpanded_dir = "/elixir-ls/language_server.sh"
   local elixirLS_dir = masonPackageLoc .. els_unexpanded_dir
   require'lspconfig'.elixirls.setup{
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
      cmd = { elixirLS_dir },
   }

   require'lspconfig'.tailwindcss.setup {
      init_options = {
         userlanguages = {
            eelixir = "html-eex",
            eruby = "erb",
            elixir = "phoenix-heex",
            heex = "phoenix-heex",
            svelte = "html",
         },
      },
      experimental = {
         classRegex = {
            [[class= "([^"]*)]],
            [[class: "([^"]*)]],
            '~H""".*class="([^"]*)".*"""',
         },
      },
      -- handlers = {
      --     ["tailwindcss/getConfiguration"] = function(_, _, params, _, bufnr, _)
      --         vim.lsp.buf_notify(bufnr, "tailwindcss/getConfigurationResponse", { _id = params._id})
      --     end,
      --},
      settings = {
         tailwindCSS = {
            lint = {
               cssConflict = "warning",
               invalidApply = "error",
               invalidConfigPath = "error",
               invalidScreen = "error",
               invalidTailwindDirective = "error",
               invalidVariant = "error",
               recommendVariantOrder = "warning",
            },
         }
      },
      classAttributes = {
         'class',
         'className',
         'classList',
         'ngClass',
      },
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
   }

   require("lspconfig").rust_analyzer.setup({
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
      settings = {
         ["rust-analyzer"] = {
            diagnostics = {
               enable = false,
            }
         }
      }
   })

   require'lspconfig'.gdscript.setup {
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
   }

   require'lspconfig'.clangd.setup {
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
   }

   omnisharp_loc = homeDir .. omnisharp_loc
   require'lspconfig'.omnisharp.setup {
      cmd = { omnisharp_loc },
      on_attach = on_attach,
      capabilities = capabilities,
      flags = lsp_flags,
      enable_editorconfig_support = true,
      enable_ms_build_load_projects_on_demand = false,
      enable_roslyn_analyzers = false,
   }

   require'lspconfig'.arduino_language_server.setup {
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
   }
end

-- CMP/Luasnip Conifiguration -----------------------------

local cmp_setup = function()
   local luasnip = require("luasnip")
   local cmp = require("cmp")
   cmp.setup({
      snippet = {
         expand = function(args)
            luasnip.lsp_expand(args.body)
         end,
      },
      mapping = cmp.mapping.preset.insert({
         ['<C-d>'] = cmp.mapping.scroll_docs(-4),
         ['<C-f>'] = cmp.mapping.scroll_docs(4),
         ['<C-Space>'] = cmp.mapping.complete(),
         ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
         },
         ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
               cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
               luasnip.expand_or_jump()
            else
               fallback()
            end
         end, { 'i', 's' }),
         ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
               cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
               luasnip.jump(-1)
            else
               fallback()
            end
         end, { 'i', 's' }),
      }),
      sources = {
         { name = 'nvim_lsp' },
         { name = 'luasnip' },
         { name = 'neorg' },
         { name = 'path' },
      },
   })
end

return {
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         {
            "SmiteshP/nvim-navbuddy",
            dependencies = {
               "SmiteshP/nvim-navic",
               "MunifTanjim/nui.nvim",
            },
            init = function()
               require("nvim-navbuddy").setup()
            end,
         }
      },
      init = lsp_setup,
   },

   {
      "hrsh7th/nvim-cmp",
      dependencies = {
         { "hrsh7th/cmp-nvim-lsp" },
         { "saadparwaiz1/cmp_luasnip" },
         { "L3MON4D3/LuaSnip" },
      },
      init = cmp_setup,
   },

   { "hrsh7th/cmp-nvim-lsp" },
   { "saadparwaiz1/cmp_luasnip" },
   { "L3MON4D3/LuaSnip" },
   {
      "williamboman/mason.nvim",
      init = function()
         require("mason").setup()
      end,
   },
}

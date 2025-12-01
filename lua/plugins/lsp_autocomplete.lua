-- LSP/AutoCompletion & DAP -------------------------------
local lsp_setup = function()
   vim.diagnostic.config({
      update_in_insert = true
   })

   local os_type = vim.loop.os_uname().sysname
   local homeDir = os.getenv("HOME")
   local dataDir = vim.fn.stdpath("data")
   local masonPackageLoc = dataDir .. '/mason/packages'
   local omnisharp_loc = ""
   if os_type == "Windows_NT" then
      homeDir = os.getenv("UserProfile")
   end

   local on_attach = function(client, bufnr)
      -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      local bufopts = { silent=true, buffer=bufnr, prefix="<leader>" }

      -- local navbuddy = require("nvim-navbuddy")
      -- local navic = require("nvim-navic")
      -- navbuddy.attach(client, bufnr)

      -- if client.server_capabilities.documentSymbolProvider then
      --    navic.attach(client, bufnr)
      -- end
      local lspsaga = require("lspsaga")

      local goto_preview = require("goto-preview")
      local wk = require("which-key")
      local lsp_server_name = "LSP: " .. client.name
      wk.add({
         mode = { "n" },
         {
            { "<leader>l", group = lsp_server_name },
            { "<leader>lD", function() goto_preview.goto_preview_definition() end, desc = "Find Declaration" },
            { "<leader>ld", function() vim.lsp.buf.definition() end, desc = "Find Definition" },
            { "<leader>lk", function() vim.lsp.buf.hover() end, desc = "Show Hover Info" },
            { "<leader>li", function() vim.lsp.buf.implementation() end, desc = "Find Implementation" },
            { "<leader>lI", function() goto_preview.goto_preview_implementation() end, desc = "Preview Implementation" },
            { "<leader>lc", function() vim.lsp.buf.code_action() end, desc = "Code Action(s)" },
            { "<leader>lr", function() goto_preview.goto_preview_references() end, desc = "Find References" },
            { "<leader>lR", function() vim.lsp.buf.rename() end,desc = "Rename Symbol" },
            { "<leader>lf", function() vim.lsp.buf.format() end,desc = "Format Buffer" },
            { "<leader>lP", function() goto_preview.close_all_win() end,  desc = "Close Preview Windows" },
            {
               { "<leader>ll", group = "Lenses" },
               { "<leader>llc", function() vim.lsp.codelens.clear() end, desc = "Clear Lens" },
               { "<leader>llr", function() vim.lsp.codelens.run() end, desc = "Run Selected Lens" },
               { "<leader>llR", function() vim.lsp.codelens.refresh() end, desc = "Refresh Lens" },
               { "<leader>lld", function() vim.lsp.codelens.display() end, desc = "Display Lens" },
            },
            {
               { "<leader>lC", group = "Calls" },
               { "<leader>lCi", function() vim.lsp.buf.incoming_calls() end, desc = "Incoming Calls" },
               { "<leader>lCo", function() vim.lsp.buf.outgooing_calls() end, desc = "Outgoing Calls" },
               { "<leader>ln", group = "Navigation" },
               { "<leader>lnn" ,  "", desc = "Navbuddy" },
            },
         },
      })
   end
   --   wk.register({
   --      l = {
   --         name = "LSP: " .. client.name,
   --         D = { function() goto_preview.goto_preview_definition() end, "Find Declaration" },
   --         d = { function() vim.lsp.buf.definition() end, "Find Definition" },
   --         k = { function() vim.lsp.buf.hover() end, "Show Hover Info" },
   --         i = { function() vim.lsp.buf.implementation() end, "Find Implementation" },
   --         I = { function() goto_preview.goto_preview_implementation() end, "Preview Implementation" },
   --         c = { function() vim.lsp.buf.code_action() end, "Code Action(s)" },
   --         r = { function() goto_preview.goto_preview_references() end, "Find References" },
   --         R = { function() vim.lsp.buf.rename() end, "Rename Symbol" },
   --         f = { function() vim.lsp.buf.format() end, "Format Buffer" },
   --         P = { function() goto_preview.close_all_win() end, "Close Preview Windows" },
   --         l = {
   --            name = "Lenses",
   --            c = { function() vim.lsp.codelens.clear() end, "Clear Lens" },
   --            r = { function() vim.lsp.codelens.run() end, "Run Selected Lens" },
   --            R = { function() vim.lsp.codelens.refresh() end, "Refresh Lens" },
   --            d = { function() vim.lsp.codelens.display() end, "Display Lens" }
   --         },
   --         C = {
   --            name = "Calls",
   --            i = { function() vim.lsp.buf.incoming_calls() end, "Incoming Calls" },
   --            o = { function() vim.lsp.buf.outgooing_calls() end, "Outgoing Calls" },
   --         },
   --      },
   --      n = {
   --         name = "Navigation",
   --         -- n = { function() navbuddy.open() end, "Navbuddy" },
   --         n = { "" , "Navbuddy" },
   --      },
   --   }, bufopts)
   --end

   local lsp_flags = {
      debounce_text_changes = 150,
   }

   local capabilities = require("blink.cmp").get_lsp_capabilities()

   vim.lsp.config.basedpyright = {
      filetypes = { "python" },
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
   }
   vim.lsp.enable("basedpyright", true)

   vim.lsp.config.kotlin_language_server = {
      filetypes = { "kotlin" },
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
   }
   vim.lsp.enable("kotlin_language_server")

   --vim.lsp.config.pyright = {
   --   before_init = function(_, config)
   --      --local stub_path = _G.join_paths(
   --      --    _G.get_runtime_dir(),
   --      --    "site",
   --      --    "pack",
   --      --    "packer",
   --      --    "opt",
   --      --    "python-type-stubs"
   --      --)
   --      --print(stub_path)
   --      local stubs = vim.fn.stdpath("data") .. "/site/pack/packer/opt/python-type-stubs"
   --      config.settings.python.analysis.stubPath = stubs
   --   end,
   --   filetypes = { "python" },
   --   on_attach = on_attach,
   --   flags = lsp_flags,
   --}
   --vim.lsp.enable("pyright", true)

   local lua_ls_path = masonPackageLoc .. "/lua-language-server/lua-language-server"
   vim.lsp.config.lua_ls = {
      on_attach = on_attach,
      flags = lsp_flags,
      cmd = { lua_ls_path },
      capabilities = capabilities,
      filetypes = { "lua" },
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
   vim.lsp.enable("lua_ls", true)

   -- Configure Elixir LS
   local els_unexpanded_dir = "/elixir-ls/language_server.sh"
   local elixirLS_dir = masonPackageLoc .. els_unexpanded_dir
   vim.lsp.config.elixirls = {
      on_attach = on_attach,
      filetypes = { "elixir", "heex"},
      flags = lsp_flags,
      capabilities = capabilities,
      cmd = { elixirLS_dir },
   }
   vim.lsp.enable("elixirls", true)

   vim.lsp.config.tailwindcss = {
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
      filetypes = { "heex", "html", "elixir" },
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
   vim.lsp.enable("tailwindcss", true)

   vim.lsp.config.rust_analyzer = {
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
      filetypes = { "rust" },
      settings = {
         ["rust-analyzer"] = {
            diagnostics = {
               enable = false,
            }
         }
      }
   }
   vim.lsp.enable("rust_analyzer", true)

   vim.lsp.config.gdscript = {
      on_attach = on_attach,
      flags = lsp_flags,
      filetypes = { "gdscript" },
      capabilities = capabilities,
   }
   vim.lsp.enable("gdscript", true)

   vim.lsp.config.clangd = {
      on_attach = function(client, bufnr)
         local bufopts = { silent=true, buffer=bufnr, prefix="<leader>" }
         local wk = require("which-key")
         wk.register({
            c = {
               name = "clangd",
               k = { "<cmd>ClangdSwitchSourceHeader<cr>" , "Swap to Header/Source" },
            },
         }, bufopts)

         on_attach(client, bufnr)
      end,
      flags = lsp_flags,
      filetypes = { "c", "cpp" },
      capabilities = capabilities,
   }
   vim.lsp.enable("clangd", true)

   vim.lsp.enable("neocmake")

   vim.lsp.config.zls = {
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
      filetypes = { "zig" },
   }
   vim.lsp.enable("zls", true)

   omnisharp_loc = masonPackageLoc .. "/omnisharp/omnisharp.cmd"
   vim.lsp.config.omnisharp = {
      cmd = { omnisharp_loc },
      on_attach = on_attach,
      capabilities = capabilities,
      flags = lsp_flags,
      enable_editorconfig_support = true,
      enable_ms_build_load_projects_on_demand = false,
      enable_roslyn_analyzers = false,
      filetypes = { "cs" },
   }
   vim.lsp.enable("omnisharp", true)

   vim.lsp.config.arduino_language_server = {
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
   }

end

return {
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         {
            "williamboman/mason.nvim",
            init = function()
               require("mason").setup()
            end,
         },
         {
            "rmagatti/goto-preview",
            init = function()
               require("goto-preview").setup()
            end
         },
         {
            "nvimdev/lspsaga.nvim",
            init = function()
               require("lspsaga").setup({
                  symbol_in_winbar = {
                     enable = false,
                  },
                  lightbulb = {
                     enable = true,
                     virtual_text = false,
                  }
               })
            end,
            dependencies = {
               "nvim-treesitter/nvim-treesitter"
            },
         }
      },
      init = lsp_setup,
   },

   {
      "saghen/blink.cmp",
      dependencies = { "rafamadriz/friendly-snippets" },
      version = "1.*",

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
         keymap = {
            preset = "enter",

            ['<Tab>'] = { "select_next", "fallback" },
            ['<S-Tab>'] = { "select_prev", "fallback" },
         },

         appearance = {
            nerd_font_variant = "mono"
         },

         completion = {
            documentation = { auto_show = true },
            accept = {
               auto_brackets = { enabled = true },
            },
         },

         signature = { enabled = true },

         sources = {
            default = { "lsp", "path", "snippets", "buffer" },
         },

         fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "source.default" }
   },

   { "microsoft/python-type-stubs", lazy = true},
   { "L3MON4D3/LuaSnip" },
}

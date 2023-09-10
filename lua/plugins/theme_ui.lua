local lualine_table = {
   options = {
      globalstatus = true,
   },
   sections = {
      lualine_a = {
         {
            'mode',
            icons_enabled = true,
            fmt = function (_, _)
               return "󰂫"
            end,
         }
      },
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
   },
   inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
   },
   tabline = {},
   winbar = {
      --lualine_z = {'filename'},
   },
}

local noice_config = function()
   require("noice").setup({
      lsp = {
         -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
         override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
         },
      },
      -- you can enable a preset for easier configuration
      presets = {
         bottom_search = true, -- use a classic bottom cmdline for search
         command_palette = true, -- position the cmdline and popupmenu together
         long_message_to_split = true, -- long messages will be sent to a split
         inc_rename = false, -- enables an input dialog for inc-rename.nvim
         lsp_doc_border = false, -- add a border to hover docs and signature help
      },
   })
end

return {
   -- Theming & UI Looks
   {
      "EdenEast/nightfox.nvim",
      lazy = false,
      priority = 1000,
      config = function()
         vim.cmd("colorscheme carbonfox")
      end,
   },

   {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
   },

   {
      "nvim-lualine/lualine.nvim",
      config = function()
         require("lualine").setup(lualine_table)
      end
   },

   {
      "rcarriga/nvim-notify",
      config = function()
         require("notify").setup()
      end
   },

   {
      "lewis6991/gitsigns.nvim",
      config = function()
         require("gitsigns").setup()
      end
   },

   {
      "goolord/alpha-nvim",
      config = function ()
         require("alpha").setup(require("alpha.themes.dashboard").config)
      end
   },

   { "MunifTanjim/nui.nvim" },

   {
      "folke/noice.nvim",
      opts = {},
      depedencies = {
         "MunifTanjim/nui.nvim",
         "rcarriga/nvim-notify",
      },
      init = noice_config,
   },

   { "kyazdani42/nvim-web-devicons" },
}

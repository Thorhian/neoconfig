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

   { "kyazdani42/nvim-web-devicons" },
}

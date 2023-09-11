--------- UI & Theming Setup ------------------------------

--------- Lua Line Setup ----------------------------------
local lualine_table = {
   options = {
      globalstatus = true,
      section_separators = { right = "", left = "" },
      component_separators = { right = "/", left = "/" },
   },
   sections = {
      lualine_a = {
         {
            'mode',
            icons_enabled = true,
            options = {
               component_separators = { left = "", right = "" }
            },
            padding = 0,
            color = { fg = "#ffff00", bg = "#ffff00" },
            fmt = function (_, _)
               return "▊"
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
   tabline = {
      -- lualine_a = {"diagnostics"},
      -- lualine_b = {},
      -- lualine_c = {},
      -- lualine_x = {},
      -- lualine_y = {},
      -- lualine_z = {"tabs"}
   },
   winbar = {
      --lualine_z = {'filename'},
   },
}
-----------------------------------------------------------

--------- Ice? Noice! -------------------------------------
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
-----------------------------------------------------------

--------- Tabline Via Tabby -------------------------------
local tabby_config = function()
   vim.o.showtabline = 2
   local theme = {
      fill = "TabLineFill",
      head = "TabLine",
      tab = "TabLine",
      win = "TabLine",
      tail = "TabLine",
   }

   require("tabby.tabline").set(function(line)
      return {
         {
            { " 󰂫 ", hl = theme.head },
            line.sep("", theme.head, theme.fill),
         },
         line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
               line.sep("", hl, theme.fill),
               tab.is_current() and '' or '',
               tab.name(),
               line.sep("", hl, theme.fill),
               hl = hl,
               margin = "  ",
            }
         end),
         line.spacer(),
         -- line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
         --    return {
         --       line.sep('', theme.win, theme.fill),
         --       win.buf_name(),
         --       line.sep("", theme.win, theme.fill),
         --       hl = theme.win,
         --       margin = " ",
         --    }
         -- end),
         {
            line.sep('', theme.tail, theme.fill),
            { '  ', hl = theme.tail },
         },
         hl = theme.fill,
      }
   end)
end
-----------------------------------------------------------

--------- Lazy Plugin Definitions -------------------------
return {
   -- Theming & UI Looks
   {
      "EdenEast/nightfox.nvim",
      lazy = false,
      priority = 1000,
      config = function()
         --vim.cmd("colorscheme carbonfox")
      end,
   },

   {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      init = function()
         vim.cmd("colorscheme tokyonight-storm")
      end,
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

   {
      "nanozuki/tabby.nvim",
      lazy = false,
      init = tabby_config,
   },

   { "kyazdani42/nvim-web-devicons" },
}
-----------------------------------------------------------

local default_mappings = function()
   local wk = require("which-key")

   wk.register({
      w = {
         name = "Windows/Panes",
         l = { "<cmd>wincmd l<cr>", "Move Right" },
         h = { "<cmd>wincmd h<cr>", "Move Left" },
         j = { "<cmd>wincmd j<cr>", "Move Down" },
         k = { "<cmd>wincmd k<cr>", "Move Up" },
         v = { "<cmd>wincmd v<cr>", "Vertical Split" },
         s = { "<cmd>wincmd s<cr>", "Horiz. Split" },
         q = { "<cmd>wincmd q<cr>", "Kill Window" },
         ["="] = { "<cmd>wincmd =<cr>", "Equalize Windows" },
         H = { "<cmd>wincmd H<cr>", "Move Window Right" },
         J = { "<cmd>wincmd J<cr>", "Move Window Down" },
         K = { "<cmd>wincmd K<cr>", "Move Window Up" },
         L = { "<cmd>wincmd L<cr>", "Move Window Left" },
         T = { "<cmd>wincmd T<cr>", "Window -> Tab" }
      },
      f = {
         name = "Files",
         f = { "<cmd>Telescope find_files<cr>", "Find Files" },
         t = { "<cmd>Neotree toggle<cr>", "Toggle NeoTree" },
         T = { "<cmd>Telescope file_browser<cr>", "Telescope File Browser" },
         r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
         s = { "<cmd>w<cr>", "Save Current File" },
      },
      p = {
         name = "Projects",
         p = { "<cmd>Telescope projects<cr>", "Browse Projects" },
      },
      e = {
         name = "Diagnostics",
         e = { function() vim.diagnostic.open_float() end, "Error Popup" },
         h = { function() vim.diagnostic.goto_prev() end, "Goto Prev Error" },
         l = { function() vim.diagnostic.goto_next() end, "Goto Next Error" },
         q = { function() vim.diagnostic.setloclist() end, "Set LocList" },
      },
      K = {
         name = "Help & Documentation",
         h = { "<cmd>Telescope help_tags<cr>", "Vim Help" },
      },
      s = {
         name = "Telescope",
         s = { "<cmd>Telescope<cr>", "All Telescope Finders" },
      },
      b = {
         name = "Buffers",
         b = { "<cmd>Telescope buffers<cr>", "List Buffers" },
         n = { "<cmd>bn<cr>", "Next Buffer" },
         p = { "<cmd>bp<cr>", "Previous Buffer" },
      },
      g = {
         name = "Git",
         g = { "<cmd>LazyGit<cr>", "Open LazyGit" },
         r = { "<cmd>Telescope live_grep<cr>", "Grep CWD" },
      },
      t = {
         name = "Terminal",
         t = { "<cmd>ToggleTerm size=60 direction=vertical<cr>", "Toggle Term" },
      },
      ["<tab>"] = {
         name = "Tabs",
         n = { "<cmd>tabnew<cr><cmd>Telescope projects<cr>", "Open Project in New Tab" },
         N = { "<cmd>tabnew<cr>", "Open New Tab" },
      },
      L = {
         name = "Lazy Pacman",
         L = { "<cmd>Lazy<cr>", "Open Lazy" },
      },
   }, { prefix = "<leader>" })
end

return {
   {
      "folke/which-key.nvim",
      lazy = false,
      priority = 1000,
      init = default_mappings,
   },

   "anuvyklack/hydra.nvim",
}

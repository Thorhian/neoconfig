local default_mappings = function()
   local wk = require("which-key")

   wk.add({
      mode = { "n" },
      {
         { "<leader>w", group = "Windows/Panes" },
         { "<leader>wl", "<cmd>wincmd l<cr>", desc = "Move Right" },
         { "<leader>wh", "<cmd>wincmd h<cr>", desc = "Move Left" },
         { "<leader>wj", "<cmd>wincmd j<cr>", desc = "Move Down" },
         { "<leader>wk", "<cmd>wincmd k<cr>", desc = "Move Up" },
         { "<leader>wv", "<cmd>wincmd v<cr>", desc = "Vertical Split" },
         { "<leader>ws", "<cmd>wincmd s<cr>", desc = "Horiz. Split" },
         { "<leader>wq", "<cmd>wincmd q<cr>", desc = "Kill Window" },
         { "<leader>w=", "<cmd>wincmd =<cr>", desc = "Equalize Windows" },
         { "<leader>wH", "<cmd>wincmd H<cr>", desc = "Move Window Right" },
         { "<leader>wJ", "<cmd>wincmd J<cr>", desc = "Move Window Down" },
         { "<leader>wK", "<cmd>wincmd K<cr>", desc = "Move Window Up" },
         { "<leader>wL", "<cmd>wincmd L<cr>", desc = "Move Window Left" },
         { "<leader>wT", "<cmd>wincmd T<cr>", desc = "Window -> Tab" },
      },
      {
         { "<leader>f", group = "Files" },
         { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
         { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "Toggle NeoTree" },
         { "<leader>fT", "<cmd>Telescope file_browser<cr>", desc = "Telescope File Browser" },
         { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
         { "<leader>fs", "<cmd>silent w<cr>", desc = "Save Current File" },
      },
      {
         { "<leader>p", group = "Projects" },
         { "<leader>pp", "<cmd>Telescope projects<cr>", desc = "Browse Projects" },
      },
      {
         { "<leader>e", group = "Diagnostics" },
         { "<leader>ee", function() vim.diagnostic.open_float() end, desc = "Error Popup" },
         { "<leader>eh", function() vim.diagnostic.goto_prev() end, desc = "Goto Prev Error" },
         { "<leader>el", function() vim.diagnostic.goto_next() end, desc = "Goto Next Error" },
         { "<leader>eq", function() vim.diagnostic.setloclist() end, desc = "Set LocList" },
      },
      {
         { "<leader>K", group = "Help & Documentation" },
         { "<leader>Kh", "<cmd>Telescope help_tags<cr>", desc = "Vim Help" },
      },
      {
         { "<leader>s", group = "Telescope" },
         { "<leader>s", "<cmd>Telescope<cr>", desc = "All Telescope Finders" },
      },
      {
         { "<leader>b", group = "Buffers" },
         { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "List Buffers" },
         { "<leader>bn", "<cmd>bn<cr>", desc = "Next Buffer" },
         { "<leader>bp", "<cmd>bp<cr>", desc = "Previous Buffer" },
      },
      {
         { "<leader>g", group = "Git" },
         { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
         { "<leader>gr", "<cmd>Telescope live_grep<cr>", desc = "Grep CWD" },
      },
      {
         { "<leader>t", group = "Terminal" },
         { "<leader>tt", "<cmd>ToggleTerm size=60 direction=vertical<cr>", desc = "Toggle Term" },
      },
      {
         { "<leader><tab>", group = "Tabs" },
         { "<leader><tab>n", "<cmd>tabnew<cr><cmd>Telescope projects<cr>", desc = "Open Project in New Tab" },
         { "<leader><tab>N", "<cmd>tabnew<cr>", desc = "Open New Tab" },
      },
      {
         { "<leader>L", group = "Lazy Pacman" },
         { "<leader>LL", "<cmd>Lazy<cr>", desc = "Open Lazy" },
      },
      {
         { "<leader>z", group = "Zen Mode" },
         { "<leader>zz", function() Snacks.zen() end, desc = "Standard Zen" }
      }
   })
end

return {
   {
      "folke/which-key.nvim",
      lazy = false,
      priority = 1200,
      init = default_mappings,
   },
}

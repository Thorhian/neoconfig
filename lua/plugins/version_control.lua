--------- GitSigns ----------------------------------------
local gitsigns_config = function()
   local gitsigns = require("gitsigns")
   gitsigns.setup({})

   local wk = require("which-key")
   wk.add({
      mode = { "n" },
      { "<leader>gs", function() gitsigns.stage_hunk() end, desc = "Stage/Unstage Hunk" },
      { "<leader>gS", function() gitsigns.stage_buffer() end, desc = "Stage Buffer" },
      { "<leader>gd", function() gitsigns.diffthis() end, desc = "Diff This Buffer" },
   })
end
-----------------------------------------------------------
return {
   {
      "kdheepak/lazygit.nvim",
      lazy = true,
      cmd = "LazyGit",
   },

   {
      "lewis6991/gitsigns.nvim",
      priority = 300,
      config = gitsigns_config
   },

   { "sindrets/diffview.nvim" }
}

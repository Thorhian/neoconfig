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
      { "<leader>gb", function() gitsigns.blame_line() end, desc = "Blame This Line" },
      { "<leader>gB", function() gitsigns.blame() end, desc = "Blame This Buffer" },
      { "<leader>gl", function() gitsigns.nav_hunk("next") end, desc = "Goto next hunk" },
      { "<leader>gH", function() gitsigns.nav_hunk("last") end, desc = "Goto last hunk" },
      { "<leader>gh", function() gitsigns.nav_hunk("prev") end, desc = "Goto previous hunk" },
      { "<leader>gH", function() gitsigns.nav_hunk("first") end, desc = "Goto first hunk" },
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

   { "sindrets/diffview.nvim" },

   {
      "NeogitOrg/neogit",
      dependencies = {
         "nvim-lua/plenary.nvim",         -- required
         "sindrets/diffview.nvim",        -- optional - Diff integration

         -- Only one of these is needed, not both.
         "nvim-telescope/telescope.nvim", -- optional
      },
      config = true
   }
}

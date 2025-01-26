--------- File Management ---------------------------------

--------- Ranger File Browser -----------------------------
local ranger_setup = function()
   local ranger = require("ranger-nvim")
   ranger.setup({
      replace_netrw = true,
   })

   local wk = require("which-key")
   wk.add({
      mode = { "n" },
      { "<leader>r", function() ranger.open(true) end, desc = "Browse Ranger" },
   })
end
-----------------------------------------------------------

--------- Oil File Browser --------------------------------
local oil_setup = function ()
   local oil = require("oil")
   oil.setup({
      -- Don't hide hidden files please :P
      view_options = {
         show_hidden = true,
      },

      columns = {
         "icon",
      },

      watch_for_changes = true,
   })

   local wk = require("which-key")
   wk.add({
      mode = { "n" },
      { "<leader>fo", "<cmd>Oil<cr>", desc = "Open Oil File Browser" }
   })
end
-----------------------------------------------------------

return {
   {
      "kelly-lin/ranger.nvim",
      init = ranger_setup
   },

   {
      "stevearc/oil.nvim",
      opts = {},
      init = oil_setup
   }
}

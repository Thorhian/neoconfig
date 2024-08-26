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

return {
   {
      "kelly-lin/ranger.nvim",
      init = ranger_setup
   },

   {
      "stevearc/oil.nvim",
      opts = {},
      init = function()
         require("oil").setup({
            view_options = {
               show_hidden = true,
            }
         })
      end,
   }
}

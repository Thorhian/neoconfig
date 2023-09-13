--------- File Management ---------------------------------

--------- Ranger File Browser -----------------------------
local ranger_setup = function()
   local ranger = require("ranger-nvim")
   ranger.setup({
      replace_netrw = true,
   })

   local wk = require("which-key")
   local wk_opts = { prefix = "<leader>" }
   local wk_binds = {
      r = { function() ranger.open(true) end , "Browse Ranger" }
   }

   wk.register(wk_binds, wk_opts)
end
-----------------------------------------------------------

return {
   {
      "kelly-lin/ranger.nvim",
      init = ranger_setup
   }
}

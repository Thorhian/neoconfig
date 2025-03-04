return {
   "folke/snacks.nvim",
   priority = 1300,
   lazy = false,
   init = snack_setup,
   opts = {
      notifier = {
         enabled = true,
         timeout = 3000,
         icons = {
            error = " ",
            warn = " ",
            info = " ",
            debug = " ",
            trace = " ",
         },
      },
      zen = {
         enabled = true,
         toggles = {
            dim = true,
            git_signs = false,
            mini_diff_signs = true
         },
      }
   }
}

return {
   {
      "akinsho/toggleterm.nvim",
      version = "*",
      init = function()
         require("toggleterm").setup({
            hide_numbers = true,
            auto_scroll = true,
            open_mapping = [[<leader>tt]],
         })
      end
   },
}

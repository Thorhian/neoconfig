return {
   -- Theming & UI Looks
   {
      "EdenEast/nightfox.nvim",
      lazy = false,
      priority = 1000,
      config = function()
         vim.cmd("colorscheme carbonfox")
      end,
   },

   {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
   },

   { "rcarriga/nvim-notify" },
   { 'kyazdani42/nvim-web-devicons' },
   { 'lewis6991/gitsigns.nvim' },
}

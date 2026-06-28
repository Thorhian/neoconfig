-- Treesitter & Formatting & Indentation
return {
   { "lukas-reineke/indent-blankline.nvim" },
   { "folke/which-key.nvim" },
   { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      dependencies = "windwp/nvim-ts-autotag",
      branch = "main",
   },
}

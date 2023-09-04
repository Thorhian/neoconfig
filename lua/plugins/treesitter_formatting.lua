-- Treesitter & Formatting & Indentation
return {
   { "jiangmiao/auto-pairs" },
   { "lukas-reineke/indent-blankline.nvim" },
   { "folke/which-key.nvim" },
   { "jiangmiao/auto-pairs" },
   { 
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      dependencies = "windwp/nvim-ts-autotag",
   },
}

-- Treesitter & Formatting & Indentation
local treesitter_setup = function()
   require'nvim-treesitter.configs'.setup {
      ensure_installed = {
         "c", "cpp", "gdscript", "lua",
         "javascript", "elixir", "eex",
         "heex", "glsl",      "python",
         "rust", "html", "vim", "regex",
         "markdown", "bash",
      },
      -- ignore_install = {  },
      sync_install = false,
      auto_install = true,

      highlight = {
         enable = true,
      },

      incremental_selection = {
         enable = true,
      },

      indent = {
         enable = true,
         disable = { "elixir" },
      },
      autotag = {
         enable = true,
         filetypes = {
            "html", "xml", "heex", "ex", "jsx", "svelte", "astro",
            "javascript", "eex"
         }
      },
   }
end

return {
   { "jiangmiao/auto-pairs" },
   { "lukas-reineke/indent-blankline.nvim" },
   { "folke/which-key.nvim" },
   { "jiangmiao/auto-pairs" },
   { 
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      dependencies = "windwp/nvim-ts-autotag",
      init = treesitter_setup,
   },
}

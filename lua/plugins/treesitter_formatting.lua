-- Treesitter & Formatting & Indentation

local required_prasers = {
   "c", "cpp", "gdscript", "lua",
   "javascript", "elixir", "eex",
   "heex", "glsl", "python",
   "rust", "html", "vim", "regex",
   "markdown", "bash",
}

local ts_setup = function()
   require("nvim-treesitter").install(required_prasers)

   vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_features", { clear = true }),
      callback = function(args)
         if not pcall(vim.treesitter.start, args.buf) then
            return
         end

         vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
         vim.wo[0][0].foldmethod = "expr"
         if args.match ~= "elixir" then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
         end
      end
   })
end

return {
   { "lukas-reineke/indent-blankline.nvim" },
   { "folke/which-key.nvim" },
   { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
   {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
      config = ts_setup,
   },
   { "windwp/nvim-ts-autotag", opts= {} },
}

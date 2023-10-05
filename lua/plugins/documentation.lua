--------- Documentation Plugins ---------------------------
local docs_view_setup = function()
   require("docs-view").setup({
      position = "right",
      width = 60,
   })
end

return {
   {
      "amrbashir/nvim-docs-view",
      init = docs_view_setup
   },
   {
      "alx741/vinfo",
      lazy = false,
   },
}

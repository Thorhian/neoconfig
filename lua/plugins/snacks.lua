local snack_setup = function()
   vim.api.nvim_create_autocmd("LspProgress", {
      ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
      callback = function(ev)
         local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
         vim.notify(vim.lsp.status(), "info", {
            id = "lsp_progress",
            title = "LSP Progress",
            opts = function(notif)
               notif.icon = ev.data.params.value.kind == "end" and " "
               or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
         })
      end,
   })
end

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
      },
      notify = { enabled = true },
   }
}


local state = {
   bufferId = nil,
   windowId = nil,
   toggle = false,
   float_dims = { width = 40, height = 10 },
}

local toggleTestFloat = function()
   if state.bufferId == nil then
      state.bufferId = vim.api.nvim_create_buf(false, true)
   end

   if state.toggle == false then
      local ui = vim.api.nvim_list_uis()[1]
      state.windowId = vim.api.nvim_open_win(state.bufferId, true, {
         relative="editor",
         row=1, col=ui.width,
         width=state.float_dims.width,
         height=state.float_dims.height
      })
      state.toggle = true
   else
      vim.api.nvim_win_close(state.windowId, true)
      state.toggle = false
   end

   print(state)
end

toggleTestFloat()

vim.api.nvim_create_user_command("TestFloat", toggleTestFloat, {})

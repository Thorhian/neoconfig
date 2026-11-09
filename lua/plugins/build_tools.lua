-- Build Tools

local configure_cmake_qf = function()
   vim.bo.errorformat = [[
      %#%f:%l %#(%m),
      %E CMake Error at %f:%l (%m):,
      %Z Call Stack (most recent call first):,
      %C %m
   ]]
end

return {
   { "Shatur/neovim-tasks"},
}

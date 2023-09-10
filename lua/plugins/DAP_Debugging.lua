local dap_config = function()
   local pickers = require("telescope.pickers")
   local finders = require("telescope.finders")
   local conf = require("telescope.config").values
   local actions = require("telescope.actions")
   local action_state = require("telescope.actions.state")

   local homeDir = os.getenv( "HOME" )
   local dataDir = vim.fn.stdpath("data")
   local masonPackageLoc = dataDir .. '/mason/packages'
   local cppExec = '/cpptools/extension/debugAdapters/bin/OpenDebugAD7'
   local elsExec = '/elixir-ls/debugger.sh'

   local os_type = vim.loop.os_uname().sysname
   local netcoredbg_loc= ""
   if os_type == "Windows_NT" then
      print("Config is loading on windows.")
      homeDir = os.getenv("UserProfile")

      netcoredbg_loc = "\\Documents\\dev_tools\\netcoredbg-win64\\netcoredbg\\netcoredbg.exe"
   end

   function File_exists(name)
      local file = io.open(name, "r")
      if file ~= nil then
         io.close(file) return true
      else
         return false end
   end


   local dap = require('dap')
   dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command = masonPackageLoc .. cppExec,
   }

   dap.configurations.cpp = {
      {
         name = "Launch file",
         type = "cppdbg",
         request = "launch",
         program = function()
            return coroutine.create(function(coro)
               local opts = {}
               pickers.new(
                  opts,
                  {
                     prompt_title = "Path to Executable",
                     finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", "--type", "x" }),
                     sorter = conf.generic_sorter(opts),
                     attach_mappings = function(buffer_number)
                        actions.select_default:replace(function()
                           actions.close(buffer_number)
                           coroutine.resume(coro, action_state.get_selected_entry()[1])
                        end)
                        return true
                     end,
                  }
               )
                  :find()
            end)
         end,
         cwd = '${workspaceFolder}',
      },
      {
         name = 'Attach to gdbserver :1234',
         type = 'cppdbg',
         request = 'launch',
         MIMode = 'gdb',
         miDebuggerServerAddress = 'localhost:1234',
         miDebuggerPath = '/usr/bin/gdb',
         cwd = '${workspaceFolder}',
         program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
         end,
      },
   }

   dap.configurations.c = dap.configurations.cpp
   dap.configurations.rust = dap.configurations.cpp

   dap.adapters.mix_task = {
      type = 'executable',
      command = masonPackageLoc .. elsExec,
      args = {}
   }

   dap.configurations.elixir = {
      {
         type = "mix_task",
         name = "mix test",
         task = 'test',
         taskArgs = {"--trace"},
         request = "launch",
         startApps = true,
         projectDir = "${workspaceFolder}",
         requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs"
         }
      },
      {
         type = "mix_task",
         name = "phx.server",
         request = "launch",
         task = "phx.server",
         projectDir = "${workspaceFolder}",
         startApps = true,
         requireFiles = {
            "lib/*"
         }
      },
   }

   dap.adapters.godot = {
      type = "server",
      host = '127.0.0.1',
      port = 6006,
   }

   dap.configurations.gdscript = {
      {
         type = "godot",
         request = "launch",
         name = "Launch scene",
         project = "${workspaceFolder}",
         launch_scene = true,
      }
   }

   netcoredbg_loc = homeDir .. netcoredbg_loc
   if File_exists(netcoredbg_loc) then
      dap.adapters.coreclr = {
         type = 'executable',
         command = netcoredbg_loc
      }

      dap.configurations.cs = {
         {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
               return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end,
         },
      }
   end
end

local dapUI_config = function()
   require("dapui").setup({
      icons = { expanded = "", collapsed = "", current_frame = "" },
      mappings = {
         -- Use a table to apply multiple mappings
         expand = { "<CR>", "<2-LeftMouse>" },
         open = "o",
         remove = "d",
         edit = "e",
         repl = "r",
         toggle = "t",
      },
      -- Use this to override mappings for specific elements
      element_mappings = {
         -- Example:
         -- stacks = {
         --   open = "<CR>",
         --   expand = "o",
         -- }
      },
      -- Expand lines larger than the window
      -- Requires >= 0.7
      expand_lines = vim.fn.has("nvim-0.7") == 1,
      -- Layouts define sections of the screen to place windows.
      -- The position can be "left", "right", "top" or "bottom".
      -- The size specifies the height/width depending on position. It can be an Int
      -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
      -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
      -- Elements are the elements shown in the layout (in order).
      -- Layouts are opened in order so that earlier layouts take priority in window sizing.
      layouts = {
         {
            elements = {
               -- Elements can be strings or table with id and size keys.
               { id = "scopes", size = 0.25 },
               "breakpoints",
               "stacks",
               "watches",
            },
            size = 40, -- 40 columns
            position = "left",
         },
         {
            elements = {
               -- "repl",
               "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
         },
      },
      controls = {
         -- Requires Neovim nightly (or 0.8 when released)
         enabled = true,
         -- Display controls in this element
         element = "repl",
         icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
         },
      },
      floating = {
         max_height = nil, -- These can be integers or a float between 0 and 1.
         max_width = nil, -- Floats will be treated as percentage of your screen.
         border = "single", -- Border style. Can be "single", "double" or "rounded"
         mappings = {
            close = { "q", "<Esc>" },
         },
      },
      windows = { indent = 1 },
      render = {
         max_type_length = nil, -- Can be integer or nil.
         max_value_lines = 100, -- Can be integer or nil.
      }
   })
end

local dap_virtual_text_setup = function()
   require('nvim-dap-virtual-text').setup({
      show_stop_reason = true,
   })
end

return {
   {
      "mfussenegger/nvim-dap",
      init = dap_config,
   },

   {
      "rcarriga/nvim-dap-ui",
      dependencies = {
         "mfussenegger/nvim-dap"
      },
      init = dapUI_config,
   },

   {
      "theHamsta/nvim-dap-virtual-text",
      init = dap_virtual_text_setup,
   },
}

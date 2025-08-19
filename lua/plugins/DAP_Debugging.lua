local dap_config = function()
   local pickers = require("telescope.pickers")
   local finders = require("telescope.finders")
   local conf = require("telescope.config").values
   local actions = require("telescope.actions")
   local action_state = require("telescope.actions.state")

   local homeDir = os.getenv("HOME")
   local dataDir = vim.fn.stdpath("data")
   local masonPackageLoc = dataDir .. "/mason/packages"
   local cppExec = "/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
   local elsExec = "/elixir-ls/debugger.sh"

   local os_type = vim.loop.os_uname().sysname
   local netcoredbg_loc = ""
   if os_type == "Windows_NT" then
      homeDir = os.getenv("UserProfile")

      netcoredbg_loc = "\\Documents\\dev_tools\\netcoredbg-win64\\netcoredbg\\netcoredbg.exe"
   end

   function File_exists(name)
      local file = io.open(name, "r")
      if file ~= nil then
         io.close(file)
         return true
      else
         return false
      end
   end

   local dap = require("dap")
   local dapVScode = require("dap.ext.vscode")
   local dapUI = require("dapui")
   local wk = require("which-key")
   --local hydra = require("hydra")

   --local stepping_hint = [[
   --   _s_: Step Over    _i_: Step Into    _o_: Step Out
   --]]

   --hydra({
   --   name = "Debug Controls",
   --   mode = "n",
   --   body = "<leader>d",
   --   hint = stepping_hint,
   --   heads = {
   --      { "s", "<cmd>DapStepOver<cr>" },
   --      { "i", "<cmd>DapStepInto<cr>" },
   --      { "o", "<cmd>DapStepOut<cr>" },
   --   }
   --})

   local hydra_step = function()
      wk.show({
         keys = "<leader>ds",
         loop = true,
         desc = "Gaben",
      })
   end

   wk.add({
      mode = { "n" },
      { "<leader>d", group = "Debugging" },
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
      { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
      { "<leader>dh", hydra_step, desc = "Hydra Stepping" },
      { "<leader>ds", "<cmd>DapStepInto<cr>", group = "Stepping"},
      { "<leader>dsi", "<cmd>DapStepInto<cr>", desc = "Step Into" },
      { "<leader>dso", "<cmd>DapStepOut<cr>", desc = "Step Out" },
      { "<leader>dss", "<cmd>DapStepOver<cr>", desc = "Step Over" },
      { "<leader>dt", function() dapUI.toggle() end, desc = "Toggle Dap UI" },
      { "<leader>dr", function()
         dapVScode.load_launchjs(nil, { cppdbg = { "rust", "c", "cpp", "h", "hpp" } })
      end, desc = "Load .vscode/launch.json" }
   })

   dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
   }

   dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      command = masonPackageLoc .. cppExec,
   }

   function table.contains(table, element)
      for _, val in pairs(table) do
         if val == element then
            return true
         end
      end
      return false
   end

   function get_lsp_workfolder(langs)
      local clients = vim.lsp.get_clients({bufnr = 0})
      if clients == nil then
         return "${workspaceFolder}"
      end

      local chosenLang = nil
      local chosenClient = nil
      for _, client in pairs(clients) do
         for _, lang in pairs(langs) do
            if table.contains(client.config.filetypes, lang) then
               chosenLang = lang
               chosenClient = client
               break
            end
         end
         if chosenLang ~= nil then
            break
         end
      end

      if chosenLang == "rust" then
         return chosenClient.root_dir
      end

      return "${workspaceFolder}"
   end

   function ExecutableFinder()
      return coroutine.create(function(coro)
         local opts = {}
         local workfolder = get_lsp_workfolder({"rust"})
         pickers.new(
            opts,
            {
               prompt_title = string.format("Path to Executable"),
               finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", "--type=x", ".", "\"", workfolder, "\"" }),
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
   end

   if os_type ~= "Windows_NT" then
      dap.configurations.cpp = {
         {
            name = "Launch file",
            type = "gdb",
            request = "launch",
            cwd = "${workspaceFolder}",
            program = ExecutableFinder,
         },
         {
            name = "Attach to gdbserver :1234",
            type = "gdb",
            request = "attach",
            target = "localhost:1234",
            cwd = "${workspaceFolder}",
            program = ExecutableFinder,
         },
      }
   else
      dap.configurations.cpp = {
         {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            cwd = "${workspaceFolder}",
            program = ExecutableFinder,
         },
         {
            name = "Attach to gdbserver :1234",
            type = "cppdbg",
            request = "launch",
            MIMode = "gdb",
            miDebuggerServerAddress = "localhost:1234",
            miDebuggerPath = "/usr/bin/gdb",
            cwd = "${workspaceFolder}",
            program = ExecutableFinder,
         },
      }
   end

   dap.configurations.c = dap.configurations.cpp
   dap.configurations.rust = dap.configurations.cpp

   dap.adapters.mix_task = {
      type = "executable",
      command = masonPackageLoc .. elsExec,
      args = {}
   }

   dap.configurations.elixir = {
      {
         type = "mix_task",
         name = "mix test",
         task = "test",
         taskArgs = { "--trace" },
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
      host = "127.0.0.1",
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

   dap.adapters.firefox = {
      type = "executable",
      command = "node",
      args = { masonPackageLoc .. "/firefox-debug-adaptor/dist/adaptor.bundle.js" },
   }

   dap.adapters.chrome = {
      type = "executable",
      command = "node",
      args = { masonPackageLoc .. "/chrome-debug-adapter/out/src/chromeDebug.js" }
   }

   dap.configurations.javascript = {
      {
         name = "Debug with Firefox",
         type = "firefox",
         request = "launch",
         reAttach = true,
         url = "http://localhost:3000",
         webRoot = "${workspaceFolder}",
         firefoxExecutable = "/usr/bin/firefox"
      }
   }

   dap.configurations.javascript = {
      {
         type = "chrome",
         request = "attach",
         program = "${file}",
         cwd = vim.fn.getcwd(),
         sourceMaps = true,
         protocol = "inspector",
         port = 9222,
         webRoot = "${workspaceFolder}"
      }
   }

   netcoredbg_loc = homeDir .. netcoredbg_loc
   if File_exists(netcoredbg_loc) then
      dap.adapters.coreclr = {
         type = "executable",
         command = netcoredbg_loc
      }

      dap.configurations.cs = {
         {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
               return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
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
               -- "stacks",
               "watches",
            },
            size = 40, -- 40 columns
            position = "left",
         },
         {
            elements = {
               "repl",
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
         max_height = nil,  -- These can be integers or a float between 0 and 1.
         max_width = nil,   -- Floats will be treated as percentage of your screen.
         border = "rounded", -- Border style. Can be "single", "double" or "rounded"
         mappings = {
            close = { "q", "<Esc>" },
         },
      },
      force_buffers = true,
      windows = { indent = 1 },
      render = {
         max_type_length = nil, -- Can be integer or nil.
         max_value_lines = 100, -- Can be integer or nil.
      }
   })
end

local dap_virtual_text_setup = function()
   require("nvim-dap-virtual-text").setup({
      show_stop_reason = true,
   })
end

return {
   {
      "mfussenegger/nvim-dap",
      dependencies = {
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
      },
      init = dap_config,
   },

}

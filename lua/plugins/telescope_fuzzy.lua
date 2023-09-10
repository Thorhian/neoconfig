-- Telescope & Fuzzy Searching

local telescope_table = {
    defaults = {
        mappings = {

        }
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        file_browser = {
            theme = "ivy",
        },
        project = {
            sync_with_nvim_tree = true,
        },
    },
}

local telescope_function = function()
   require("telescope").setup(telescope_table)
   require('telescope').load_extension('fzf')
   require('telescope').load_extension('projects')
end

return {
   {
      "nvim-telescope/telescope.nvim", version = "0.1.2",
      dependencies = {
         { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
         {
            "ahmedkhalf/project.nvim",
            config = function()
               require("project_nvim").setup()
            end
         },
      },
      config = telescope_function,
   },
}

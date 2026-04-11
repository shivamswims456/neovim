-- =============================================================================
-- lua/plugins/telescope.lua
-- =============================================================================

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-frecency.nvim", dependencies = { "kkharji/sqlite.lua" } },
    },
    cmd  = "Telescope",
    -- Keys here only for lazy-loading trigger; actual mappings live in keymaps.lua
    keys = { "<leader>f", "<leader>F", "<leader>FW", "<leader>g" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          -- Use fd: hidden files, no .git prefix noise
          find_command = {
            "fd", "--type", "f", "--hidden", "--strip-cwd-prefix",
          },
          file_ignore_patterns = {
            "node_modules", ".git/", "dist", "build",
            ".next", "target", "venv", "env", "__pycache__",
          },
          sorting_strategy = "ascending",
          layout_strategy  = "horizontal",
          layout_config = {
            width  = 0.95,
            height = 0.9,
            horizontal = {
              preview_width  = 0.7,
              results_width  = 0.3,
              prompt_position = "top",
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
        },
        extensions = {
          fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,
            override_file_sorter    = true,
            case_mode               = "smart_case",
          },
          frecency = {
            show_scores    = false,
            show_unindexed = true,
            ignore_patterns = { "*.git/*", "*/tmp/*" },
          },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("frecency")
    end,
  },
}

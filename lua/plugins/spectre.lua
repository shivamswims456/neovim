-- =============================================================================
-- lua/plugins/spectre.lua
-- =============================================================================

return {
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>R",  function() require("spectre").open() end,                            desc = "Spectre: open" },
      { "<leader>Rw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Spectre: word under cursor" },
      { "<leader>Rf", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Spectre: current file" },
    },
    config = function()
      require("spectre").setup({
        highlight = {
          ui      = "String",
          search  = "DiffChange",
          replace = "DiffDelete",
        },
        mapping = {
          ["toggle_line"] = {
            map  = "dd",
            cmd  = "<cmd>lua require('spectre').toggle_line()<CR>",
            desc = "toggle item",
          },
          ["replace_cmd"] = {
            map  = "<CR>",
            cmd  = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
            desc = "replace current line",
          },
          ["replace_all"] = {
            map  = "<leader>a",
            cmd  = "<cmd>lua require('spectre.actions').replace_cmd({select_all=true})<CR>",
            desc = "replace all",
          },
        },
      })
    end,
  },
}

-- =============================================================================
-- lua/plugins/ufo.lua
-- =============================================================================

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    config = function()
      -- foldcolumn/foldlevel are set in options.lua
      require("ufo").setup({
        -- Use LSP + treesitter as fold providers, fallback to indent
        provider_selector = function(_, filetype, _)
          local ft_map = {
            python     = { "treesitter", "indent" },
            typescript = { "lsp", "treesitter" },
            javascript = { "lsp", "treesitter" },
          }
          return ft_map[filetype] or { "treesitter", "indent" }
        end,
      })

      -- Remap zR/zM to ufo's handlers
      vim.keymap.set("n", "zR", require("ufo").openAllFolds,  { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
    end,
  },
}

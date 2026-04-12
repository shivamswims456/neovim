-- =============================================================================
-- lua/plugins/toggleterm.lua
-- =============================================================================

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { "<C-\\>" },
    config = function()
      require("toggleterm").setup({
        open_mapping    = [[<C-\>]],
        direction       = "float",
        float_opts = {
          border   = "curved",
          width    = math.floor(vim.o.columns * 0.85),
          height   = math.floor(vim.o.lines * 0.8),
          winblend = 3,
        },
        shade_terminals = false,
        persist_mode    = true,   -- remember insert/normal mode between toggles
      })

      -- Use <Esc> or <C-\> to close the terminal from terminal mode
      vim.keymap.set("t", "<Esc>",  [[<C-\><C-n>]],          { desc = "Exit terminal mode" })
      vim.keymap.set("t", "<C-\\>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], { desc = "Toggle terminal" })
    end,
  },
}

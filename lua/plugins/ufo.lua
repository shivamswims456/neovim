return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    config = function()
      vim.o.foldcolumn     = "0"
      vim.o.foldlevel      = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable     = true

      require("ufo").setup({
        -- Don't let ufo touch statuscolumn at all
        fold_virt_text_handler = nil,
        provider_selector = function(_, filetype, _)
          local ft_map = {
            python     = { "treesitter", "indent" },
            typescript = { "lsp", "treesitter" },
            javascript = { "lsp", "treesitter" },
          }
          return ft_map[filetype] or { "treesitter", "indent" }
        end,
      })

      -- Override whatever ufo sets on each buffer after it attaches
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        callback = function()
          vim.opt_local.foldcolumn = "0"
          vim.opt_local.statuscolumn = ""
        end,
      })

      vim.keymap.set("n", "zR", require("ufo").openAllFolds,  { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
    end,
  },
}

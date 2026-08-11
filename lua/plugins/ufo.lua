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
      vim.o.statuscolumn   = ""

      require("ufo").setup({
        provider_selector = function(_, filetype, _)
          -- Lit's `.prop=${}` / `?bool=${}` / `@evt=${}` bindings aren't valid
          -- HTML, so the injected html parser inside html`` produces an ERROR
          -- tree with no (element) nodes — treesitter folds find nothing there
          -- and tsserver's LSP folds don't reach into template strings either.
          -- Indent-based folding works on the raw text and nests <div> blocks
          -- inside html`` correctly regardless of ${} content.
          local indent_first = {
            javascript = true,
          }
          if indent_first[filetype] then
            return { "indent" }
          end
          return { "lsp", "indent" }
        end,
      })

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

-- =============================================================================
-- lua/plugins/conform.lua
-- =============================================================================

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      javascript      = { "prettier" },
      javascriptreact = { "prettier" },
      typescript      = { "prettier" },
      typescriptreact = { "prettier" },
      json            = { "prettier" },
      css             = { "prettier" },
      html            = { "prettier" },
      markdown        = { "prettier" },
      yaml            = { "prettier" },
      sql             = { "sql_formatter" },
    },
    formatters = {
      prettier = {
        args = { "--stdin-filepath", "$FILENAME" },
      },
      sql_formatter = {
        command = "sql-formatter",
        args    = { "--language", "mysql" },
      },
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)

    vim.api.nvim_create_user_command("Format", function()
      require("conform").format({ async = true, lsp_fallback = false })
    end, {})
  end,
}

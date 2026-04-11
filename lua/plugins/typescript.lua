-- =============================================================================
-- lua/plugins/typescript.lua
-- =============================================================================

return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client)
          -- Disable tsserver formatting — prettier via conform handles it
          -- Keymaps applied globally via LspAttach autocmd in plugins/init.lua
          client.server_capabilities.documentFormattingProvider = false
        end,
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints        = "all",
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints          = true,
          },
        },
      })
    end,
  },
}

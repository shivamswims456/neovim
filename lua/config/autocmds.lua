-- =============================================================================
-- lua/config/autocmds.lua
-- =============================================================================

-- Show diagnostics float on CursorHold
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

-- After LSP rename: save all modified buffers (matches original handler)
local orig_rename = vim.lsp.handlers["textDocument/rename"]
vim.lsp.handlers["textDocument/rename"] = function(err, result, ctx, config)
  orig_rename(err, result, ctx, config)
  vim.cmd("wa")
end

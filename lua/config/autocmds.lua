-- =============================================================================
-- lua/config/autocmds.lua
-- =============================================================================

-- Show diagnostics float on CursorHold
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

-- Pyright sends annotatedTextEdits in rename responses but omits the required
-- top-level changeAnnotations map, causing nvim to assert-fail. Strip the
-- annotationId from every edit before the default handler processes it.
local orig_rename = vim.lsp.handlers["textDocument/rename"]
vim.lsp.handlers["textDocument/rename"] = function(err, result, ctx, config)
  if result and result.documentChanges then
    for _, change in ipairs(result.documentChanges) do
      if change.edits then
        for _, edit in ipairs(change.edits) do
          edit.annotationId = nil
        end
      end
    end
  end
  orig_rename(err, result, ctx, config)
  vim.cmd("wa")
end

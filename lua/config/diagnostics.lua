-- =============================================================================
-- lua/config/diagnostics.lua
-- =============================================================================

vim.diagnostic.config({
  virtual_text    = false,   -- shown via CursorHold float instead
  severity_sort   = true,
  update_in_insert = false,
  float = {
    border = "rounded",
    wrap   = true,
    source = true,
  },
})

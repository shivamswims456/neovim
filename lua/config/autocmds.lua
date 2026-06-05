-- =============================================================================
-- lua/config/autocmds.lua
-- =============================================================================

-- Ensure css`...` in Lit files gets real CSS highlighting.
-- tree-sitter-manager's ecma queries map css`` to "styled" (no parser).
-- We build the javascript injections from ecma+jsx source directly so
-- this survives tree-sitter-manager reinstalling those query files.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local site = vim.fn.stdpath("data") .. "/site/queries"
    local function read(path)
      local fh = io.open(path)
      if not fh then return "" end
      local s = fh:read("*a"); fh:close(); return s
    end
    local combined = read(site .. "/ecma/injections.scm")
      .. "\n" .. read(site .. "/jsx/injections.scm")
      .. "\n" .. [[
; Lit: css`...` → real CSS (overrides ecma's css→styled mapping)
(call_expression
  function: (identifier) @_tag
  (#eq? @_tag "css")
  arguments: (template_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "css"))
]]
    pcall(vim.treesitter.query.set, "javascript", "injections", combined)
  end,
})

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

-- Enforce no extra columns on every buffer — overrides plugins that set them
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
  callback = function()
    vim.opt_local.foldcolumn  = "0"
    vim.opt_local.signcolumn  = "no"
    vim.opt_local.statuscolumn = ""
  end,
})

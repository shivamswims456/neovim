-- Minimal OpenFGA setup for Neovim 0.11+, using only the official server.
local server = vim.env.FGA_LSP or vim.fn.expand("~/.local/share/openfga-lsp/server.node.js")

vim.filetype.add({
  extension = { fga = "fga", openfga = "fga" },
  filename = { ["fga.mod"] = "yaml.fgastore" },
  pattern = {
    [".*%.fga%.yaml"] = "yaml.fgastore",
    [".*%.openfga%.yaml"] = "yaml.fgastore",
  },
})

vim.lsp.config("openfga", {
  cmd = { "node", server, "--stdio" },
  filetypes = { "fga", "yaml.fgastore" },
  root_markers = { "fga.mod", ".git" },
  handlers = {
    -- Non-standard request the server sends to read files that are not open
    -- (module files listed in fga.mod, model_file in .fga.yaml).
    -- VS Code's client answers it; Neovim needs this handler.
    getFileContents = function(_, params)
      local uri = type(params) == "table" and params[1] or params
      local ok, lines = pcall(vim.fn.readfile, vim.uri_to_fname(uri))
      if not ok then
        return nil, vim.lsp.rpc.rpc_response_error(vim.lsp.protocol.ErrorCodes.InternalError, "not found: " .. uri)
      end
      return table.concat(lines, "\n")
    end,
  },
})

vim.lsp.enable("openfga")

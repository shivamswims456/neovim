-- =============================================================================
-- lua/config/commands.lua — user commands from original LunarVim config
-- =============================================================================

-- Copy current file's absolute path to system clipboard
vim.api.nvim_create_user_command("Cp", function()
  local path = vim.fn.expand("%:p")
  if path ~= "" then
    vim.fn.setreg("+", path)
    print("Copied: " .. path)
  else
    print("No file in buffer")
  end
end, {})

-- Add Pyright type-ignore comment for diagnostic on current line
vim.api.nvim_create_user_command("PyrightIgnoreLine", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local row   = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = row })

  if #diagnostics == 0 then
    print("No diagnostic on this line")
    return
  end

  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
  local ignored_codes = {}

  for _, diag in ipairs(diagnostics) do
    if diag.source == "pyright" and diag.code then
      table.insert(ignored_codes, diag.code)
    end
  end

  if #ignored_codes == 0 then
    line = line .. "  # type: ignore"
  else
    line = line .. "  # type: ignore[" .. table.concat(ignored_codes, ",") .. "]"
  end

  vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, { line })
  print("Added type-ignore comment")
end, {})

-- :O1 … :O9 — jump to buffer by ordinal (bufferline)
for i = 1, 9 do
  vim.api.nvim_create_user_command("O" .. i, function()
    vim.cmd("BufferLineGoToBuffer " .. i)
  end, {})
end

-- :TsInit — generate tsconfig.json
vim.api.nvim_create_user_command("TsInit", function()
  vim.cmd("!tsc --init")
end, {})

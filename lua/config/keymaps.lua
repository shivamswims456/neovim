-- =============================================================================
-- lua/config/keymaps.lua — ported from LunarVim config
-- =============================================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- =============================================================================
-- Utility
-- =============================================================================

map("n", "<C-x>", ":bd!<CR>", vim.tbl_extend("force", opts, { desc = "Force close buffer" }))

-- =============================================================================
-- Explorer
-- =============================================================================

-- <leader>e is also declared in ui.lua keys spec (for lazy-loading).
-- Declaring here too is harmless and ensures it's documented centrally.
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", vim.tbl_extend("force", opts, { desc = "Explorer toggle" }))

-- =============================================================================
-- Telescope
-- =============================================================================

-- Find files (like VSCode Ctrl+P)
map("n", "<leader>f", function()
  require("telescope.builtin").find_files()
end, vim.tbl_extend("force", opts, { desc = "Find files" }))

-- Find strings / live grep (like VSCode Ctrl+Shift+F)
map("n", "<leader>F", function()
  require("telescope.builtin").live_grep()
end, vim.tbl_extend("force", opts, { desc = "Live grep (project)" }))

-- Grep word under cursor
map("n", "<leader>FW", function()
  require("telescope.builtin").grep_string()
end, vim.tbl_extend("force", opts, { desc = "Grep word under cursor" }))

-- Recent files via frecency
map("n", "<leader>g", "<cmd>Telescope frecency<CR>", vim.tbl_extend("force", opts, { desc = "Frecency (recent files)" }))

-- =============================================================================
-- Spectre (find & replace)
-- =============================================================================

map("n", "<leader>R", function()
  require("spectre").open()
end, vim.tbl_extend("force", opts, { desc = "Spectre: open" }))

map("n", "<leader>Rw", function()
  require("spectre").open_visual({ select_word = true })
end, vim.tbl_extend("force", opts, { desc = "Spectre: word under cursor" }))

map("n", "<leader>Rf", function()
  require("spectre").open_file_search({ select_word = true })
end, vim.tbl_extend("force", opts, { desc = "Spectre: current file" }))

-- =============================================================================
-- Session (auto-session)
-- =============================================================================

map("n", "<leader>ss", ":SaveSession<CR>",    vim.tbl_extend("force", opts, { desc = "Save session" }))
map("n", "<leader>sr", ":RestoreSession<CR>", vim.tbl_extend("force", opts, { desc = "Restore session" }))
map("n", "<leader>sd", ":DeleteSession<CR>",  vim.tbl_extend("force", opts, { desc = "Delete session" }))

-- =============================================================================
-- Python / swenv
-- =============================================================================

map("n", "<leader>Cc", "<cmd>lua require('swenv.api').pick_venv()<CR>",
  vim.tbl_extend("force", opts, { desc = "Python: choose venv" }))

-- =============================================================================
-- Neotest / DAP
-- =============================================================================

map("n", "<leader>dm", "<cmd>lua require('neotest').run.run()<CR>",
  vim.tbl_extend("force", opts, { desc = "Test: run method" }))
map("n", "<leader>dM", "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<CR>",
  vim.tbl_extend("force", opts, { desc = "Test: run method (DAP)" }))
map("n", "<leader>df", "<cmd>lua require('neotest').run.run({ vim.fn.expand('%') })<CR>",
  vim.tbl_extend("force", opts, { desc = "Test: run file" }))
map("n", "<leader>dF", "<cmd>lua require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' })<CR>",
  vim.tbl_extend("force", opts, { desc = "Test: run file (DAP)" }))
map("n", "<leader>dS", "<cmd>lua require('neotest').summary.toggle()<CR>",
  vim.tbl_extend("force", opts, { desc = "Test: summary" }))

-- =============================================================================
-- Renamer (F2)
-- =============================================================================

map("n", "<F2>", function()
  require("renamer").rename()
end, { desc = "Rename symbol (popup)" })

-- =============================================================================
-- TypeScript tools
-- =============================================================================

map("n", "<leader>oi", "<cmd>TSToolsOrganizeImports<CR>",   { desc = "TS: Organize imports" })
map("n", "<leader>rf", "<cmd>TSToolsRenameFile<CR>",        { desc = "TS: Rename file" })
map("n", "<leader>ia", "<cmd>TSToolsAddMissingImports<CR>", { desc = "TS: Add missing imports" })
map("n", "<leader>ru", "<cmd>TSToolsRemoveUnused<CR>",      { desc = "TS: Remove unused" })

-- =============================================================================
-- Format
-- =============================================================================

map("n", "<leader>lf", "<cmd>Format<CR>", { desc = "Format file" })

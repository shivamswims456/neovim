-- =============================================================================
-- lua/config/options.lua
-- =============================================================================

local opt = vim.opt

-- Session options (from original config)
if not string.find(vim.o.sessionoptions, "localoptions") then
  vim.o.sessionoptions = vim.o.sessionoptions .. ",localoptions"
end

-- Folding (nvim-ufo)
opt.foldcolumn     = "1"
opt.foldlevel      = 99
opt.foldlevelstart = 99
opt.foldenable     = true

-- Editing
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.signcolumn     = "yes"
opt.wrap           = false
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.tabstop        = 2
opt.shiftwidth     = 2
opt.expandtab      = true
opt.smartindent    = true
opt.splitbelow     = true
opt.splitright     = true
opt.termguicolors  = true
opt.updatetime     = 250
opt.timeoutlen     = 500
opt.clipboard      = "unnamedplus"
opt.ignorecase     = true
opt.smartcase      = true

-- =============================================================================
-- lua/config/options.lua
-- =============================================================================

local opt = vim.opt

-- Session options: explicitly exclude localoptions so sessions never
-- save/restore display settings like foldcolumn, signcolumn etc.
vim.o.sessionoptions = vim.o.sessionoptions:gsub(",localoptions", ""):gsub("localoptions,", ""):gsub("localoptions", "")

-- Folding (nvim-ufo)
opt.foldcolumn     = "0"   -- no fold column
opt.foldlevel      = 99
opt.foldlevelstart = 99
opt.foldenable     = true
opt.statuscolumn   = ""    -- clear any statuscolumn (removes ufo fold level numbers)

-- Editing
opt.number         = true
opt.relativenumber = false
opt.cursorline     = true
opt.signcolumn     = "no"
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

-- =============================================================================
-- init.lua
-- =============================================================================

-- Bootstrap lazy.nvim
--
--

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader      = " "
vim.g.maplocalleader = " "
-- in your init.lua, after colorscheme is set
require("lazy").setup("plugins", {
  change_detection = { notify = false },
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.diagnostics")
require("config.commands")

-- after your colorscheme line
local hl = vim.api.nvim_set_hl
hl(0, "@variable.parameter", { fg = "#00BBC9" }) -- kwarg name: username=
hl(0, "@module.python", { fg = "#0897B4" })

-- =============================================================================
-- lua/plugins/init.lua
-- lazy.nvim loads all files returned from this directory automatically.
-- This file collects simple/single-line specs; complex ones are split out.
-- =============================================================================

return {
  -- --------------------------------------------------------------------------
  -- Colorscheme
  -- --------------------------------------------------------------------------
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({})
      vim.cmd("colorscheme github_dark_dimmed")
    end,
  },

  -- --------------------------------------------------------------------------
  -- Treesitter
  -- --------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = { "python", "typescript", "tsx", "javascript", "lua" },
      highlight        = { enable = true },
      indent           = { enable = true },
      auto_install     = true,
    },
  },

  -- --------------------------------------------------------------------------
  -- LSP layer (mason + lspconfig)
  -- --------------------------------------------------------------------------
  { "williamboman/mason.nvim",           build = ":MasonUpdate", config = true },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "williamboman/mason.nvim" } },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    lazy = false,
    config = function()
      -- Mason: ensure servers are installed
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "lua_ls" },
      })

      -- Inject cmp capabilities into every server via the wildcard config.
      -- Server-specific settings live in ~/.config/nvim/lsp/<server>.lua
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      vim.lsp.enable({ "pyright", "lua_ls" })

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(ev)
          local bufopts = { noremap = true, silent = true, buffer = ev.buf }
          vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     bufopts)
          vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,    bufopts)
          vim.keymap.set("n", "gr",         vim.lsp.buf.references,     bufopts)
          vim.keymap.set("n", "gi",         vim.lsp.buf.implementation, bufopts)
          vim.keymap.set("n", "K",          vim.lsp.buf.hover,          bufopts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,         bufopts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,    bufopts)
        end,
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- Completion
  -- --------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp    = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible()       then cmp.select_next_item()
            elseif luasnip.expandable() then luasnip.expand()
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- UI helpers
  -- --------------------------------------------------------------------------
  { "nvim-lua/plenary.nvim", lazy = true },
  { "stevearc/dressing.nvim", event = "VeryLazy", config = true },
  { "MeanderingProgrammer/render-markdown.nvim", opts = {} },

  -- --------------------------------------------------------------------------
  -- Python: virtual-env switcher
  -- --------------------------------------------------------------------------
  { "ChristianChiarulli/swenv.nvim" },

  -- --------------------------------------------------------------------------
  -- Statusline (lualine with github theme)
  -- --------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme        = "auto",  -- picks up github_dark_dimmed automatically
        globalstatus = true,
      },
    },
  },
}

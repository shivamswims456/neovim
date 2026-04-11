-- =============================================================================
-- lua/plugins/editing.lua — autopairs, surround, multi-cursor, renamer
-- =============================================================================

return {
  -- --------------------------------------------------------------------------
  -- Auto pairs (treesitter-aware)
  -- --------------------------------------------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        check_ts                    = true,
        enable_check_bracket_line   = true,
        map_cr                      = false,
        fast_wrap = {
          map       = "<C-e>",
          chars     = { "(", "{", "[", "\"", "'" },
          pattern   = [=[[%'%"%)%>%]%)%}%,]]=],
          offset    = 0,
          end_key   = "$",
          keys      = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma     = true,
          highlight       = "Search",
          highlight_grey  = "Comment",
        },
      })
      -- cmp integration
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- --------------------------------------------------------------------------
  -- Surround (mini)
  -- --------------------------------------------------------------------------
  {
    "echasnovski/mini.surround",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.surround").setup({
        mappings = {
          add     = "S",  -- visual: select + S + char
          delete  = "D",
          replace = "R",
          find    = "F",
        },
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- Multi-cursor (vim-visual-multi)
  -- --------------------------------------------------------------------------
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_leader           = "\\"
      vim.g.VM_default_mappings = 0
      vim.g.VM_maps = {
        ["Find Under"]         = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Select All"]         = "<C-a>",
        ["Skip"]               = "<C-x>",
        ["Remove Region"]      = "<C-p>",
        ["Add Cursor Down"]    = "<C-Down>",
        ["Add Cursor Up"]      = "<C-Up>",
        ["Select Cursor Down"] = "<M-Down>",
        ["Select Cursor Up"]   = "<M-Up>",
        ["Switch Mode"]        = "<Tab>",
      }
    end,
  },

  -- --------------------------------------------------------------------------
  -- Renamer (F2 popup rename)
  -- --------------------------------------------------------------------------
  {
    "filipdutescu/renamer.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { "<F2>" },
    config = function()
      require("renamer").setup({
        title        = "Rename Symbol",
        padding      = { top = 0, left = 1, bottom = 0, right = 1 },
        border       = true,
        border_chars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        show_refs    = true,
        with_qf_list = true,
      })
    end,
  },
}

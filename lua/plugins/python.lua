-- =============================================================================
-- lua/plugins/python.lua
-- =============================================================================

return {
  -- DAP core
  {
    "mfussenegger/nvim-dap",
    lazy = true,
  },

  -- Python DAP adapter
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
      -- Same path used by LunarVim's dap-python setup
      local debugpy = mason_path .. "packages/debugpy/venv/bin/python"
      pcall(function()
        require("dap-python").setup(debugpy)
      end)
    end,
  },

  -- DAP UI (replaces LunarVim's built-in dap UI)
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI" },
    },
    config = function()
      local dap    = require("dap")
      local dapui  = require("dapui")
      dapui.setup()
      -- Auto-open/close UI on DAP events
      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open()  end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
    end,
  },

  -- Async IO required by neotest
  { "nvim-neotest/nvim-nio", lazy = true },

  -- Neotest + Python adapter
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
    },
    ft  = "python",
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end,                      desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,    desc = "Run file tests" },
      { "<leader>ts", function() require("neotest").summary.toggle() end,               desc = "Test summary" },
      { "<leader>to", function() require("neotest").output_panel.toggle() end,          desc = "Test output" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = {
              justMyCode = false,
              console    = "integratedTerminal",
            },
            args   = { "--log-level", "DEBUG", "--quiet" },
            runner = "pytest",
          }),
        },
      })
    end,
  },
}

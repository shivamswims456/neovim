-- =============================================================================
-- lua/plugins/ui.lua — nvim-tree, bufferline, indent-blankline, auto-session
-- =============================================================================

return {
  -- --------------------------------------------------------------------------
  -- File explorer
  -- --------------------------------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.g.loaded_netrw       = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    cmd  = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = { { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer toggle" } },
    config = function()
      require("nvim-tree").setup({
        on_attach = function(bufnr)
          local api     = require("nvim-tree.api")
          local bufopts = { noremap = true, silent = true, buffer = bufnr }

          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.set("n", "r", function()
            local node = api.tree.get_node_under_cursor()
            vim.ui.input({ prompt = "Rename to: ", default = node.name }, function(new_name)
              if new_name and #new_name > 0 then
                vim.cmd("edit " .. node.absolute_path)
                vim.cmd("RopeRename " .. new_name)
                api.tree.reload()
              end
            end)
          end, bufopts)
        end,
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- Bufferline (ordinal numbers, :O1–O9)
  -- --------------------------------------------------------------------------
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        numbers = "ordinal",
        sort_by = "id",
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- Indent guides
  -- --------------------------------------------------------------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    main  = "ibl",
    config = function()
      require("ibl").setup({
        indent  = { char = "│" },
        scope   = { enabled = true },
        exclude = {
          filetypes = { "help", "dashboard", "NvimTree" },
          buftypes  = { "terminal" },
        },
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- Session management (git-root aware)
  -- --------------------------------------------------------------------------
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      if not string.find(vim.o.sessionoptions, "localoptions") then
        vim.o.sessionoptions = vim.o.sessionoptions .. ",localoptions"
      end

      local session_root = vim.fn.stdpath("data") .. "/sessions/"

      local function get_session_name()
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if git_root and git_root ~= "" and vim.v.shell_error == 0 then
          return vim.fn.fnamemodify(git_root, ":t")
        else
          return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        end
      end

      require("auto-session").setup({
        log_level                        = "info",
        auto_session_enable_last_session = false,
        auto_session_root_dir            = session_root,
        auto_session_use_git_branch      = false,
        auto_session_create_enabled      = true,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern  = "AutoSessionSavePre",
        callback = function()
          local name = get_session_name()
          vim.g.auto_session_last_session = session_root .. name .. ".vim"
        end,
      })

      vim.api.nvim_create_autocmd("VimEnter", {
        nested = true,  -- allow autocmds triggered by the restored buffers
        callback = function()
          -- Don't restore if nvim was opened with explicit file/dir arguments
          if vim.fn.argc() > 0 then return end

          local name = get_session_name()
          local path = session_root .. name .. ".vim"
          if vim.fn.filereadable(path) ~= 1 then return end

          -- Suppress E325 swap-file attention prompt during restore
          local saved_shortmess = vim.o.shortmess
          vim.o.shortmess = vim.o.shortmess .. "A"

          local ok, err = pcall(vim.cmd, "RestoreSession")

          vim.o.shortmess = saved_shortmess

          if not ok then
            vim.notify(
              "auto-session: restore failed — " .. tostring(err),
              vim.log.levels.WARN
            )
          end
        end,
      })
    end,
  },
}

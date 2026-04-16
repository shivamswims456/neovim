return {
  --------------------------------------------------
  -- 🧠 Markdown Preview (browser - reliable)
  --------------------------------------------------
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_theme = "dark"
    end,
  },

  --------------------------------------------------
  -- 🖼️ Image backend (Kitty native)
  --------------------------------------------------
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",        -- 🔥 now works!
      processor = "magick_cli",

      rocks = {
        enabled = false,
        hererocks = false,
      },
    },
  },

  --------------------------------------------------
  -- 📊 Diagram rendering
  --------------------------------------------------
  {
    "3rd/diagram.nvim",
    dependencies = { "3rd/image.nvim" },
    ft = { "markdown" },

    opts = {
      events = {
        render_buffer = { "BufWinEnter", "InsertLeave" }, -- ⚡ reduced lag
        clear_buffer = { "BufLeave" },
      },

      renderer_options = {
        mermaid = {
          theme = "dark",
          background = "transparent",
          scale = 2, -- 👈 sharper in Kitty
        },
      },
    },

    config = function(_, opts)
      require("diagram").setup(opts)

      vim.keymap.set("n", "<leader>dr", ":DiagramRender<CR>", { desc = "Render diagram" })
      vim.keymap.set("n", "<leader>dc", ":DiagramClear<CR>", { desc = "Clear diagram" })
    end,
  },
}

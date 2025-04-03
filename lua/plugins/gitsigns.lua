return {
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
        numhl = true, -- Highlight line numbers
        linehl = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local opts = { noremap = true, silent = true, buffer = bufnr }

          -- Keymaps
          vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts)
          vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts)
          vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
          vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts)
          vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, opts) -- Show inline git blame
          vim.keymap.set("n", "<leader>gd", gs.diffthis, opts) -- Show git diff
        end,
      })
    end,
  },
}



return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local ok, gitsigns = pcall(require, "gitsigns")
      if not ok then return end

      gitsigns.setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
          untracked    = { text = "┆" },
        },
        signcolumn = true,         -- Show symbols in the sign column
        numhl = true,              -- Highlight line numbers (your requested behavior)
        linehl = false,
        word_diff = false,

        attach_to_untracked = true, -- Show signs for new files, too
        watch_gitdir = {
          interval = 200,           -- Faster polling so highlights clear quickly after commits
          follow_files = true,
        },

        current_line_blame = false, -- Toggle with <leader>hb
        current_line_blame_opts = {
          delay = 500,
          virt_text_pos = "eol",
        },

        preview_config = { border = "rounded" },

        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
          end

          -- Navigation
          map("n", "]h", gs.next_hunk, "Next hunk")
          map("n", "[h", gs.prev_hunk, "Prev hunk")

          -- Actions
          map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
          map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
          map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
          map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
          map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
          map("n", "<leader>hb", gs.toggle_current_line_blame, "Toggle blame")
          map("n", "<leader>hd", gs.diffthis, "Diff this")
          map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff against HEAD")
          map("n", "<leader>ht", gs.toggle_deleted, "Toggle deleted")
        end,
      })

      -- Refresh gitsigns when returning from external tools (e.g., lazygit)
      vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("GitsignsRefresh", { clear = true }),
        callback = function()
          if package.loaded.gitsigns then
            require("gitsigns").refresh()
          end
        end,
      })

      -- If you use kdheepak/lazygit.nvim, refresh on exit too
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyGitExit",
        group = vim.api.nvim_create_augroup("GitsignsRefreshLazyGit", { clear = true }),
        callback = function()
          if package.loaded.gitsigns then
            require("gitsigns").refresh()
          end
        end,
      })
    end,
  },
}


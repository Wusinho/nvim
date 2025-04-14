return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- Optional: For file icons
    },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        update_cwd = true,
        view = {
          width = 30,
          side = "left",
          adaptive_size = true,  -- Improves efficiency by dynamically adjusting size
        },
        renderer = {
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
            },
            glyphs = {
              default = "",
              symlink = "",
              git = {
                unstaged = "",
                staged = "✓",
                untracked = "★",
              },
            },
          },
          highlight_opened_files = "name",  -- Highlight opened files
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
        filters = {
          custom = { "^.git$" },  -- Optionally hide git files or any other files
        },
        git = {
          ignore = false,  -- Show files ignored by Git (e.g., .env)
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

      -- Show hidden files
      vim.g.nvim_tree_show_hidden = 1

      -- Automatically open the file explorer on startup (optional)
      vim.cmd('autocmd VimEnter * NvimTreeOpen')
    end,
  },
}


return {
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required dependency
    },
    config = function()
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { noremap = true, silent = true })
    end,
  },
}


return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- recommended UI opts
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          -- try LSP first (Ruby LSP provides folding ranges), then indent
          return { "lsp", "indent" }
        end,
      })

      -- optional: peek folded text
      vim.keymap.set("n", "zK", function() require("ufo").peekFoldedLinesUnderCursor() end,
        { desc = "Peek fold", silent = true })
    end,
  },
}

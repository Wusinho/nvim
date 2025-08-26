return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = { "lua", "javascript", "typescript", "css", "bash", "regex", "sql", "markdown", "markdown_inline", "json", "html", "yaml", "ruby" },
       sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true }
      })
    end
  }
}

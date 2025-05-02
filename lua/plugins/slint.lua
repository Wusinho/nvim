return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls") -- 🔥 keep this as "null-ls", NOT "none-ls"

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettier,
      },
    })
  end
}


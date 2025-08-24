return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls") -- keep as null-ls

    local sources = {
      null_ls.builtins.formatting.prettier,
    }

    -- Conditionally enable ESLint if config file exists
    if vim.fn.filereadable(".eslintrc.js") == 1 or vim.fn.filereadable(".eslintrc.json") == 1 then
      table.insert(sources, null_ls.builtins.diagnostics.eslint)
      table.insert(sources, null_ls.builtins.code_actions.eslint) -- Add code actions (fixes)
    end

    null_ls.setup({
      sources = sources,
      root_dir = require("null-ls.utils").root_pattern(".git", "package.json", ".eslintrc.js", ".eslintrc.json"),
    })
  end
}

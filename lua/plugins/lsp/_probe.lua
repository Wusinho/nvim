
-- Minimal, known-good spec to prove the import works
return {
  "neovim/nvim-lspconfig",
  ft = "lua",
  config = function()
    require("lspconfig").lua_ls.setup({})
  end,
}

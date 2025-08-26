return {
  "neovim/nvim-lspconfig",
  ft = "lua",
  config = function()
    local lspconfig = require("lspconfig")
    local shared = require("lsp.shared")
    lspconfig.lua_ls.setup({
      on_attach = shared.on_attach_common,
      capabilities = shared.capabilities,
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })
  end,
}

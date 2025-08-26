return {
  "neovim/nvim-lspconfig",
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  config = function()
    local lspconfig = require("lspconfig")
    local shared = require("lsp.shared")

    local function on_attach_ts(client, bufnr)
      shared.on_attach_common(client, bufnr)

      -- Let ESLint handle fixes; avoid double-format writers
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    lspconfig.ts_ls.setup({
      on_attach = on_attach_ts,
      capabilities = shared.capabilities,
    })

    -- ESLint: single source of "save" edits for TS/JS
    lspconfig.eslint.setup({
      on_attach = function(client, bufnr)
        shared.on_attach_common(client, bufnr)
        local grp = vim.api.nvim_create_augroup("eslint_fix_on_save", { clear = false })
        vim.api.nvim_clear_autocmds({ group = grp, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = grp,
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
      capabilities = shared.capabilities,
    })
  end,
}

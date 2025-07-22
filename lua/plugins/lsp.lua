return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Shared on_attach function
    local function on_attach(client, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', '<leader>cd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', '<leader>cr', vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, bufopts)
      vim.keymap.set('n', '<leader>cc', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)

      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end

    -- TypeScript LSP
    lspconfig.ts_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- Ruby LSP with Rails Add-on and Standard formatting/linting

    lspconfig.ruby_lsp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { "/home/hlazo/.rbenv/shims/ruby-lsp" },
      filetypes = { "ruby", "eruby" },
      settings = {
        rubyLsp = {
          formatter = 'standard',
          linters = { 'standard' },
          addonSettings = {
            ["Ruby LSP Rails"] = {
              enablePendingMigrationsPrompt = true,
            },
          },
        },
      },
    })

    -- Lua LSP
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            -- Use LuaJIT for Neovim
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Recognize the global 'vim'
            globals = { 'vim' },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false, -- Avoid "Do you want to configure lua-dev?"
          },
          telemetry = {
            enable = false, -- No telemetry data collection
          },
        },
      },
    })
    -- ESLint LSP
    lspconfig.eslint.setup({
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
      capabilities = capabilities,
    })
  end
}

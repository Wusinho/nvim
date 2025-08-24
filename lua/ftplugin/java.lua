-- ~/.config/nvim/ftplugin/java.lua
local jdtls = require("jdtls")

-- Determine root directory
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then return end

-- Setup capabilities and on_attach
local capabilities = vim.lsp.protocol.make_client_capabilities()
local function on_attach(client, bufnr)
  -- Custom mappings like in your lsp.lua
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<leader>cd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

  -- Format on save
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end
end

-- Define workspace folder
local workspace_folder = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- Set config for jdtls
local config = {
  cmd = { "jdtls" }, -- mason should add jdtls to your path
  root_dir = root_dir,
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    java = {
      eclipse = { downloadSources = true },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all", -- literals, all, none
        },
      },
      format = {
        enabled = true,
      },
    },
  },
  init_options = {
    bundles = {},
  },
}

jdtls.start_or_attach(config)

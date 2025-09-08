-- lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    local shared = require("lsp.shared") -- your helper with on_attach_common/capabilities

    -- at the top of config(), after requiring util/shared:
    local function ruby_lsp_cmd(root_dir)
      root_dir = root_dir or vim.loop.cwd()
      local has_gemfile = require("lspconfig.util").root_pattern("Gemfile")(root_dir)
      if has_gemfile and vim.fn.executable("bundle") == 1 then
        return { "bundle", "exec", "ruby-lsp" }
      end
      if vim.fn.executable("rvm-auto-ruby") == 1 then
        return { "bash", "-lc", "rvm-auto-ruby -S ruby-lsp" }
      end
      return { "ruby-lsp" } -- rbenv/asdf/system
    end

    -- Ruby LSP: RuboCop as formatter + linter, with format-on-save
    lspconfig.ruby_lsp.setup({
      on_attach = function(client, bufnr)
        shared.on_attach_common(client, bufnr)

        -- allow Ruby LSP to format (it calls RuboCop under the hood)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true

        -- (re)create a buffer-local format-on-save just for ruby_lsp
        local grp = vim.api.nvim_create_augroup("ruby_lsp_format_on_save_" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = grp,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              bufnr = bufnr,
              async = false,
              timeout_ms = 5000,
              filter = function(c) return c.name == "ruby_lsp" end,
            })
          end,
        })
      end,
      capabilities = shared.capabilities,
      cmd = ruby_lsp_cmd(vim.loop.cwd()),
      filetypes = { "ruby", "eruby" },
      root_dir = util.root_pattern("Gemfile", ".git"),
      init_options = {
        formatter     = "rubocop",
        linters       = { "rubocop" },
        addonSettings = {
          ["Ruby LSP Rails"] = { enablePendingMigrationsPrompt = true },
        },
      },
    })



    ---------------------------------------------------------------------------
    -- Lua (lua_ls)
    ---------------------------------------------------------------------------
    lspconfig.lua_ls.setup({
      on_attach = function(client, bufnr)
        -- keep your shared behavior
        shared.on_attach_common(client, bufnr)

        -- ensure lua_ls can format
        client.server_capabilities.documentFormattingProvider = true

        -- format on save, filtered to lua_ls
        local grp = vim.api.nvim_create_augroup("lua_ls_format_on_save_" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = grp,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              bufnr = bufnr,
              timeout_ms = 3000,
              filter = function(c) return c.name == "lua_ls" end,
            })
          end,
        })
      end,
      capabilities = shared.capabilities,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
          format = { enable = true }, -- ← important
        },
      },
    })

    ---------------------------------------------------------------------------
    -- TypeScript / JavaScript (ts_ls) + ESLint
    -- Disable ts_ls formatting so ESLint is the single writer on save.
    ---------------------------------------------------------------------------
    lspconfig.ts_ls.setup({
      on_attach = function(client, bufnr)
        shared.on_attach_common(client, bufnr)

        -- allow ts_ls to format
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true

        -- format on save, filtered to ts_ls
        local grp = vim.api.nvim_create_augroup("ts_ls_format_on_save_" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = grp,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              bufnr = bufnr,
              timeout_ms = 3000,
              filter = function(c) return c.name == "ts_ls" end,
            })
          end,
        })
      end,
      capabilities = shared.capabilities,
      settings = {
        typescript = {
          tsserver = { useSyntaxServer = "auto" },
          format = { semicolons = "insert" },
        },
        javascript = {
          format = { semicolons = "insert" },
        },
      },
    })

    lspconfig.eslint.setup({
      on_attach = function(client, bufnr)
        shared.on_attach_common(client, bufnr)

        -- keep ESLint for diagnostics/code actions; do not let it format
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- run fixes AFTER the file is written/formatted by ts_ls
        local grp = vim.api.nvim_create_augroup("eslint_fix_after_save_" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd("BufWritePost", {
          group = grp,
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
      capabilities = shared.capabilities,
      settings = { workingDirectory = { mode = "auto" } },
    })
  end,
}

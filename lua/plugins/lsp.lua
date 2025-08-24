return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- format-on-save that *forces* ruby_lsp to be the formatter
    local function on_attach(client, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', '<leader>cd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', '<leader>cr', vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', '<leader>cf', function()
        vim.lsp.buf.format({
          bufnr = bufnr,
          filter = function(c) return c.name == "ruby_lsp" end,
        })
      end, bufopts)
      vim.keymap.set('n', '<leader>cc', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)

      -- format on save (Ruby will go through ruby_lsp -> StandardRB)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(c) return c.name == "ruby_lsp" end,
          })
        end,
      })
    end

    -- choose the right Ruby LSP command for the project
    local function ruby_lsp_cmd(root_dir)
      root_dir = root_dir or vim.loop.cwd()

      -- Prefer Bundler if Gemfile exists (matches project Ruby & gems)
      local has_gemfile = util.root_pattern("Gemfile")(root_dir)
      if has_gemfile and vim.fn.executable("bundle") == 1 then
        return { "bundle", "exec", "ruby-lsp" }
      end

      -- Use RVM if available
      if vim.fn.executable("rvm-auto-ruby") == 1 then
        -- load RVM env and run ruby-lsp from current ruby/gemset
        return { "bash", "-lc", "rvm-auto-ruby -S ruby-lsp" }
      end

      -- Fall back to PATH (rbenv/asdf/system)
      return { "ruby-lsp" }
    end

    -- TypeScript LSP (unchanged)
    lspconfig.ts_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- ✅ Ruby LSP — format with StandardRB, lint with RuboCop
    lspconfig.ruby_lsp.setup({
      on_attach = on_attach,
      capabilities = capabilities,

      cmd = ruby_lsp_cmd(vim.loop.cwd()),
      cmd_env = { RUBYOPT = "-W0" }, -- quiet Ruby/Bundler warnings

      filetypes = { "ruby", "eruby" },
      root_dir = util.root_pattern("Gemfile", ".git"),

      -- Ruby LSP reads init_options (not settings.rubyLsp)
      init_options = {
        formatter     = "standard",    -- <- formatting via StandardRB
        linters       = { "rubocop" }, -- <- diagnostics via RuboCop
        addonSettings = {
          ["Ruby LSP Rails"] = { enablePendingMigrationsPrompt = true },
          ["RuboCop"] = { enabled = true },
        },
      },
    })

    -- Lua LSP
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
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

    -- ESLint LSP (fix on save)
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

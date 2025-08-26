return {
  "neovim/nvim-lspconfig",
  ft = { "ruby", "eruby" },
  config = function()
    local lspconfig = require("lspconfig")
    local shared = require("lsp.shared")
    local util = require("lspconfig.util")

    local function ruby_lsp_cmd(root_dir)
      root_dir = root_dir or vim.loop.cwd()
      local has_gemfile = util.root_pattern("Gemfile")(root_dir)
      if has_gemfile and vim.fn.executable("bundle") == 1 then
        return { "bundle", "exec", "ruby-lsp" }
      end
      if vim.fn.executable("rvm-auto-ruby") == 1 then
        return { "bash", "-lc", "rvm-auto-ruby -S ruby-lsp" }
      end
      return { "ruby-lsp" } -- rbenv/asdf/system
    end

    local function on_attach_ruby(client, bufnr)
      shared.on_attach_common(client, bufnr)

      -- Ruby-only format-on-save through ruby_lsp (StandardRB)
      local grp = vim.api.nvim_create_augroup("ruby_lsp_format_on_save", { clear = false })
      vim.api.nvim_clear_autocmds({ group = grp, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = grp,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(c) return c.name == "ruby_lsp" end,
          })
        end,
      })
    end

    lspconfig.ruby_lsp.setup({
      on_attach = on_attach_ruby,
      capabilities = shared.capabilities,
      cmd = ruby_lsp_cmd(vim.loop.cwd()),
      filetypes = { "ruby", "eruby" },
      root_dir = util.root_pattern("Gemfile", ".git"),
      init_options = {
        formatter = "standard",
        linters   = { "standard" },
        addonSettings = {
          ["Ruby LSP Rails"] = { enablePendingMigrationsPrompt = true },
        },
      },
    })
  end,
}

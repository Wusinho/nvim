return {
  "neovim/nvim-lspconfig",
  ft = { "ruby", "eruby" }, -- starts when you open .rb or .erb
  config = function()
    vim.notify("ruby spec loaded", vim.log.levels.WARN)
    local lspconfig = require("lspconfig")
    local util      = require("lspconfig.util")

    local function ruby_lsp_cmd(root)
      root = root or vim.loop.cwd()
      if util.root_pattern("Gemfile")(root) and vim.fn.executable("bundle") == 1 then
        return { "bundle", "exec", "ruby-lsp" } -- use project gems
      end
      return { "ruby-lsp" } -- fallback to shim
    end

    lspconfig.ruby_lsp.setup({
      cmd       = ruby_lsp_cmd(vim.loop.cwd()),
      root_dir  = util.root_pattern("Gemfile", ".git"),
      filetypes = { "ruby", "eruby" },

      -- IMPORTANT: Neovim ruby-lsp reads init_options (not settings)
      init_options = {
        formatter = "standard",      -- or "rubocop"
        linters   = { "standard" },  -- or { "rubocop" }
      },

      on_attach = function(_, bufnr)
        -- Ruby-only format on save
        local g = vim.api.nvim_create_augroup("ruby_lsp_format_on_save", { clear = false })
        vim.api.nvim_clear_autocmds({ group = g, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = g, buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              bufnr = bufnr,
              filter = function(c) return c.name == "ruby_lsp" end,
            })
          end,
        })
      end,
    })
  end,
}

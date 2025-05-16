return {
  "rmagatti/auto-session",
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.sessionoptions = "buffers,curdir,tabpages,winsize,globals,help,localoptions,folds"

    local status_ok, auto_session = pcall(require, "auto-session")
    if not status_ok then return end

    auto_session.setup({
      enabled = true,
      root_dir = vim.fn.stdpath("data") .. "/sessions/",
      auto_save = true,
      auto_restore = true,
      auto_create = true,
      suppressed_dirs = { "~", "~/Downloads", "/", "/tmp" },
      auto_restore_last_session = false, -- ✅ Only restore matching project session
      git_use_branch_name = true,
      git_auto_restore_on_branch_change = false,
      lazy_support = true,
      close_unsupported_windows = true,
      log_level = "error",
    })
    vim.api.nvim_create_autocmd({ "BufWritePost", "WinClosed", "VimLeavePre" }, {
      callback = function()
        local ok, session = pcall(require, "auto-session")
        if ok then
          session.SaveSession()
        end
      end,
    })
    vim.keymap.set("n", "<leader>ar", "<cmd>SessionRestore<CR>", { desc = "Manual Restore Session" })
    vim.keymap.set("n", "<leader>as", "<cmd>SessionSave<CR>", { desc = "Manual Save Session" })
  end,
}

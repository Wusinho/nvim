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
      auto_save = true,                  -- ✅ Always save on quit
      auto_restore = true,               -- ✅ Always try to restore on enter
      auto_create = true,                -- ✅ Create session if none exists
      auto_restore_last_session = false, -- ✅ Only restore matching cwd session
      git_use_branch_name = true,
      git_auto_restore_on_branch_change = false,
      lazy_support = true,
      close_unsupported_windows = true,
      log_level = "debug",
    })

    vim.keymap.set("n", "<leader>ar", "<cmd>SessionRestore<CR>", { desc = "Manual Restore Session" })
    vim.keymap.set("n", "<leader>as", "<cmd>SessionSave<CR>", { desc = "Manual Save Session" })
  end,
}

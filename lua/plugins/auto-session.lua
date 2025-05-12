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
      auto_save = true,    -- Auto-save on exit
      auto_restore = true, -- Auto-restore on startup
      auto_create = true,  -- Create session if not existing
      suppressed_dirs = { "~", "~/Downloads", "/", "/tmp" },
      auto_restore_last_session = true,
      git_use_branch_name = true,
      git_auto_restore_on_branch_change = false,
      lazy_support = true,
      close_unsupported_windows = true,
      log_level = "error",

    })
  end,
}

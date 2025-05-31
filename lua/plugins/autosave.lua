return {
  {
    "pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        enabled = true,                            -- Enable auto-save
        execution_message = {
          message = function() return "" end,      -- Hide message on save
        },
        events = { "InsertLeave", "TextChanged" }, -- Auto-save on leaving insert mode & changes
        conditions = {
          exists = true,
          filename_is_not = {},
          filetype_is_not = { "gitcommit" }, -- Avoid auto-saving commits
        },
        write_all_buffers = false,           -- Save only the current buffer
        debounce_delay = 200,                -- Save delay in milliseconds
      })
    end,
  },
}

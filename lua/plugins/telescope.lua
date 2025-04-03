return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- Add FZF
    },
    config = function ()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git" }, -- Ignore unnecessary files
          sorting_strategy = "ascending",
        },
        pickers = {
          find_files = {
            hidden = true,
            theme = "ivy"
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- Enable fuzzy searching
            override_generic_sorter = true,  -- Use fzf for general sorting
            override_file_sorter = true,     -- Use fzf for file sorting
            case_mode = "smart_case",        -- Ignore case unless uppercase used
          },
        },
      })

      -- Load FZF extension
      require("telescope").load_extension("fzf")

      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
      vim.keymap.set('n', '<leader>st', builtin.live_grep, {})
    end
  }
}


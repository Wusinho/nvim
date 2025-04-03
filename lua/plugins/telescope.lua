
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
          file_ignore_patterns = { "node_modules", ".git" },
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            theme = "ivy",
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" }, -- Uses ripgrep for better search
          },
          live_grep = {
            additional_args = function(_) return { "--unrestricted" } end, -- Ensure it searches all files
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- Enable fuzzy searching
            override_generic_sorter = true, -- Override default sorter
            override_file_sorter = true, -- Override file sorter
            case_mode = "smart_case", -- Case-insensitive unless uppercase is used
          },
        },
      })

      -- Load FZF extension
      require("telescope").load_extension("fzf")

      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = "Find files" })
      vim.keymap.set('n', '<leader>st', builtin.live_grep, { desc = "Search text" })
    end
  }
}



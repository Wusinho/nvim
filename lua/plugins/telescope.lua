
return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-frecency.nvim', dependencies = { 'tami5/sqlite.lua' } },
    },
    config = function ()
      local telescope = require("telescope")

      telescope.setup({
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
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
          },
          live_grep = {
            additional_args = function(_) return { "--unrestricted" } end,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          frecency = {
            show_scores = true,
            show_unindexed = false,
            ignore_patterns = { "*.git/*", "*/tmp/*" },
            workspaces = {},
            db_safe_mode = false,
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("frecency")

      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = "Find files" })
      vim.keymap.set('n', '<leader>st', builtin.live_grep, { desc = "Search text" })
      -- Only define project-specific frecency keymap


vim.keymap.set('n', '<leader>sr', function()
  require('telescope').extensions.frecency.frecency({
    workspace = "CWD", -- properly scope to current project
    path_display = { "shorten" },
    theme = "ivy",
  })
end, { desc = "Recent files (project only)" })

    end
  }
}

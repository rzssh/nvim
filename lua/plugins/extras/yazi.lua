return {
  "mikavilpas/yazi.nvim",
  cmd = { "Yazi" },
  dependencies = {
    "folke/snacks.nvim",
  },
  -- stylua: ignore
  keys = {
    { "<leader>-", function () vim.cmd("Yazi") end, desc = "Yazi: Current file", mode = { "n", "v" },  },
    { "<leader>fw", function() vim.cmd("Yazi cwd") end, desc = "Yazi: Working directory" },
    -- { "<c-up>", function() vim.cmd("Yazi toggle") end, desc = "Resume the last yazi session" },
  },
  ---@type YaziConfig | {}
  opts = {
    -- NOTE: Currently using oil.nvim as a netrw interface, could switch to true to replace
    open_for_directories = false,
    keymaps = {
      show_help = "?",
      -- NOTE: for reference
      --
      -- open_file_in_vertical_split = "<c-v>",
      -- open_file_in_horizontal_split = "<c-x>",
      -- open_file_in_tab = "<c-t>",
      -- grep_in_directory = "<c-s>",
      -- replace_in_directory = "<c-g>",
      -- cycle_open_buffers = "<tab>",
      -- copy_relative_path_to_selected_files = "<c-y>",
      -- send_to_quickfix_list = "<c-q>",
      -- change_working_directory = "<c-\\>",
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    -- vim.g.loaded_netrwPlugin = 1
  end,
}

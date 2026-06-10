return {
  "lewis6991/gitsigns.nvim",
  event = "LazyFile",
  opts = {
    signcolumn = false,
    numhl = false,
    linehl = false,
    word_diff = false,
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 250,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "  <author>, <author_time:%R> · <summary>",
  },
  keys = {
    { "<leader>gB", function() require("gitsigns").blame_line({ full = true }) end, desc = "Git blame line (popup)" },
    { "<leader>tb", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle inline blame" },
  },
}

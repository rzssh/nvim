return {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  keys = {
    { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Git changes" },
    { "<leader>gh", "<cmd>CodeDiff history %<cr>", desc = "File history" },
    { "<leader>gH", "<cmd>CodeDiff history<cr>", desc = "Repository history" },
    {
      "<leader>gh",
      function()
        vim.cmd("'<,'>CodeDiff history")
      end,
      mode = "x",
      desc = "Selection history",
    },
  },
}

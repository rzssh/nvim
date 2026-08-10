return {
  "CoreyKaylor/diffbandit.nvim",
  version = "*",
  cmd = {
    "DiffBandit",
    "DiffBanditBuffers",
    "DiffBanditFolderDiff",
    "DiffBanditGit",
    "DiffBanditGitCurrent",
    "DiffBanditCommitPanel",
    "DiffBanditGitMenu",
    "DiffBanditGitLog",
    "DiffBanditGitCommit",
    "DiffBanditGitCompare",
    "DiffBanditGitCheckout",
    "DiffBanditMerge",
  },
  opts = {},
  keys = {
    { "<leader>gd", "<cmd>DiffBanditGit<cr>", desc = "Git changes" },
    {
      "<leader>gh",
      function()
        require("diffbandit").git_log({
          all = true,
          max_count = 50,
          pathspecs = { vim.api.nvim_buf_get_name(0) },
        })
      end,
      desc = "File history",
    },
    {
      "<leader>gH",
      "<cmd>DiffBanditGitLog --all --max-count 50<cr>",
      desc = "Repository history",
    },
  },
}

return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    picker = "snacks",
    use_local_fs = true,
    enable_builtin = true,
  },
  keys = {
    { "<leader>Op", "<cmd>Octo pr list<cr>", desc = "Octo: PR list" },
    { "<leader>Oi", "<cmd>Octo issue list<cr>", desc = "Octo: issue list" },
    { "<leader>Or", "<cmd>Octo review start<cr>", desc = "Octo: start review" },
  },
  init = function()
    require("which-key").add({
      { "<leader>O", group = "GitHub (Octo)" },
    })
  end,
}

local function annotate(line)
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= "" and vim.fs.root(path, ".jj") then
    vim.cmd("J " .. (line and "annotate_line" or "annotate"))
  else
    vim.cmd("BlameToggle " .. (line and "virtual" or "window"))
  end
end

return {
  {
    "FabijanZulj/blame.nvim",
    cmd = "BlameToggle",
    opts = {},
    init = function()
      vim.keymap.set("n", "<leader>gB", function()
        annotate(false)
      end, { desc = "File attribution" })
      vim.keymap.set("n", "<leader>ub", function()
        annotate(true)
      end, { desc = "Line attribution" })
    end,
  },

  {
    "NicolasGB/jj.nvim",
    version = "*",
    cmd = "J",
    dependencies = { "esmuellert/codediff.nvim" },
    keys = {
      { "<leader>jl", "<cmd>J log<cr>", desc = "JJ: Log" },
      { "<leader>js", "<cmd>J status<cr>", desc = "JJ: Status" },
    },
    opts = {
      diff = { backend = "codediff" },
    },
  },

  {
    "julienvincent/hunk.nvim",
    cmd = "DiffEditor",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },

  {
    "rafikdraoui/jj-diffconflicts",
    cmd = "JJDiffConflicts",
  },
}

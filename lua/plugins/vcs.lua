local function annotate(line)
  vim.cmd("BlameToggle " .. (line and "virtual" or "window"))
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
}

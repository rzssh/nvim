return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  opts = {},
  keys = {
    {
      "<leader>xq",
      function()
        require("quicker").toggle()
      end,
      desc = "Toggle quickfix",
    },
    {
      "<leader>xd",
      function()
        local quicker = require("quicker")

        if quicker.is_open() then
          quicker.close()
        else
          vim.diagnostic.setloclist()
        end
      end,
      desc = "Toggle buffer diagnostics",
    },
    {
      "<leader>xD",
      function()
        local quicker = require("quicker")

        if quicker.is_open() then
          quicker.close()
        else
          vim.diagnostic.setqflist()
        end
      end,
      desc = "Toggle project diagnostics",
    },
    {
      ">",
      function()
        local quicker = require("quicker")

        if quicker.is_open() then
          quicker.expand({ before = 2, after = 2, add_to_existing = true })
          return
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(">", true, false, true), "n", false)
      end,
      desc = "Expand context",
    },
    {
      "<",
      function()
        local quicker = require("quicker")

        if quicker.is_open() then
          quicker.collapse()
          return
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<", true, false, true), "n", false)
      end,
      desc = "Collapse context",
    },
  },
  init = function()
    require("which-key").add({
      { "<leader>x", group = "Quickfix", icon = { icon = "!", color = "red" } },
    })
  end,
}

return {
  "eero-lehtinen/oklch-color-picker.nvim",
  event = "LazyFile",
  version = "*",
  ---@type oklch.Opts
  opts = {},
  keys = {
    {
      "<leader>pc",
      function()
        require("oklch-color-picker").pick_under_cursor()
      end,
      desc = "Color pick under cursor",
    },
  },
}

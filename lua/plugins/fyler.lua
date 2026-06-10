return {
  "A7Lavinraj/fyler.nvim",
  event = "LazyFile",
  cmd = { "Fyler" },
  dependencies = { "nvim-mini/mini.icons" },
  opts = {
    views = {
      finder = {
        win = {
          -- float | replace | split_left | split_left_most | split_above | split_above_all | split_right | split_right_most | split_below | split_below_all
          -- kind = "float",
          kind = "split_right_most",
          kinds = {
            -- height | width | top | bottom | left | right | win_opts
            float = {
              height = "70%",
              width = "25%",
              top = "20%",
              left = "100%",
            },
            split_right_most = {
              width = "25%",
              win_opts = {
                winfixwidth = true,
              },
            },
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>ea",
      function()
        require("fyler").toggle()
      end,
      mode = "n",
      desc = "Open Fyler View",
    },
  },
}

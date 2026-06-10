return {
  "MagicDuck/grug-far.nvim",
  opts = {
    windowCreationCommand = "vsplit | vertical resize 50",
    prefills = {
      flags = "--multiline --smart-case --hidden --sortr=modified --fixed-strings",
      filesFilter = [[
!node_modules
!*-lock.{json,yaml}
!*.lock
]],
    },
    keymaps = {
      openNextLocation = { n = "<C-j>" },
      openPrevLocation = { n = "<C-k>" },
    },
  },
  keys = {
    {
      "<leader>fs",
      function()
        require("grug-far").toggle_instance({ instanceName = "far", staticTitle = "Find and Replace" })
      end,
      mode = { "n", "v" },
      desc = "Search and replace",
    },
  },
}

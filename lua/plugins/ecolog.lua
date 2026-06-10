return {
  "philosofonusus/ecolog.nvim",
  opts = {
    integrations = {
      blink_cmp = true,
      statusline = {
        hidden_mode = true,
      },
      snacks = {
        shelter = {
          mask_on_copy = false,
        },
        keys = {
          copy_value = "<C-y>",
          copy_name = "<C-u>",
          append_value = "<C-a>",
          append_name = "<CR>",
          edit_var = "<C-e>",
        },
        layout = {
          preset = "dropdown",
          preview = false,
        },
      },
    },
    shelter = {
      configuration = {
        mask_char = "█",
        partial_mode = {
          show_start = 3,
          show_end = 3,
          min_mask = 3,
        },
      },
      modules = {
        files = true,
        peek = false,
        cmp = false,
        snacks = false,
      },
    },
    path = vim.fn.getcwd(),
    preferred_environment = "local",
  },
  keys = {
    { "<leader>se", "<cmd>EcologPeek<cr>", desc = "Peek Env Var" },
    { "<leader>sE", "<cmd>EcologSelect<cr>", desc = "Select Env File" },
    { "<leader>sg", "<cmd>EcologGoto<cr>", desc = "Goto Env Definition" },
  },
}

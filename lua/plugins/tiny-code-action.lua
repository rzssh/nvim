return {
  "rachartier/tiny-code-action.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  event = "LspAttach",
  opts = {
    -- "vim", "delta", "difftastic", "diffsofancy"
    backend = "vim",
    -- "telescope", "snacks", "select", "buffer", "fzf-lua"
    picker = "snacks",
    resolve_timeout = nil,
    notify = { enabled = true, on_empty = true },
  },
}

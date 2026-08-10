return {
  "mrcjkb/rustaceanvim",
  version = "^9",
  lazy = false,
  keys = {
    { "<leader>rr", "<cmd>RustLsp runnables<cr>", desc = "Rust runnables", ft = "rust" },
    { "<leader>rt", "<cmd>RustLsp testables<cr>", desc = "Rust testables", ft = "rust" },
    { "<leader>re", "<cmd>RustLsp expandMacro<cr>", desc = "Expand macro", ft = "rust" },
    { "<leader>rc", "<cmd>RustLsp openCargo<cr>", desc = "Open Cargo.toml", ft = "rust" },
    { "<leader>rp", "<cmd>RustLsp parentModule<cr>", desc = "Parent module", ft = "rust" },
  },
  init = function()
    vim.g.rustaceanvim = {
      dap = {
        autoload_configurations = false,
        adapter = false,
      },
    }
  end,
}

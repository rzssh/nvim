return {
  name = "cargo build",
  builder = function()
    return {
      cmd = { "cargo", "build", "--message-format", "short" },
      components = { { "on_output_quickfix", open = false, items_only = true }, "default" },
    }
  end,
  condition = { filetype = { "rust" } },
}

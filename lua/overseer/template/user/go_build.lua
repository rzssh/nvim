return {
  name = "go build",
  builder = function()
    return {
      cmd = { "go", "build", "./..." },
      components = { { "on_output_quickfix", open = false, items_only = true }, "default" },
    }
  end,
  condition = { filetype = { "go" } },
}

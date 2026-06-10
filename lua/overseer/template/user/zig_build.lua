return {
  name = "zig build",
  builder = function()
    return {
      cmd = { "zig", "build" },
      components = { { "on_output_quickfix", open = false, items_only = true }, "default" },
    }
  end,
  condition = { filetype = { "zig" } },
}

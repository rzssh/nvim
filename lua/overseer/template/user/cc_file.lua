return {
  name = "cc file",
  builder = function()
    local file = vim.fn.expand("%:p")
    local out = vim.fn.stdpath("cache") .. "/cc_out"
    return {
      cmd = { "cc", "-Wall", "-Wextra", "-g", file, "-o", out },
      components = { { "on_output_quickfix", open = false, items_only = true }, "default" },
    }
  end,
  condition = { filetype = { "c" } },
}

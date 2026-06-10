return {
  name = "c++ file",
  builder = function()
    local file = vim.fn.expand("%:p")
    local out = vim.fn.stdpath("cache") .. "/cpp_out"
    return {
      cmd = { "c++", "-Wall", "-Wextra", "-g", file, "-o", out },
      components = { { "on_output_quickfix", open = false, items_only = true }, "default" },
    }
  end,
  condition = { filetype = { "cpp" } },
}

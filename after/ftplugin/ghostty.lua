vim.bo.commentstring = "# %s"

local ok = pcall(vim.treesitter.start)
if not ok then
  vim.notify(
    "Ghostty parser not available, using basic syntax",
    vim.log.levels.WARN,
    { title = "Tree-sitter" }
  )
end

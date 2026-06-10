local uv = vim.uv or vim.loop

local function exists(p)
  return uv.fs_stat(p) ~= nil
end

local function find_root()
  local buf = vim.api.nvim_buf_get_name(0)
  local start = (buf ~= "" and vim.fs.dirname(buf)) or vim.fn.getcwd()
  local markers = {
    "pnpm-lock.yaml",
    "yarn.lock",
    "package-lock.json",
    "bun.lock",
    "bun.lockb",
    "package.json",
    ".git",
  }
  local found = vim.fs.find(markers, { upward = true, path = start })[1]
  return found and vim.fs.dirname(found) or vim.fn.getcwd()
end

local function pm(root)
  if exists(root .. "/pnpm-lock.yaml") then
    return { "pnpm", "-s" }
  end
  if exists(root .. "/yarn.lock") then
    return { "yarn", "-s" }
  end
  if exists(root .. "/bun.lockb") or exists(root .. "/bun.lock") then
    return { "bun" }
  end
  return { "npm", "run", "--silent" }
end

local function qf()
  return { "on_output_quickfix", open = false, items_only = true }
end

return {
  name = "tsc",
  builder = function()
    local root = find_root()
    local p = pm(root)

    local cmd
    if p[1] == "npm" then
      cmd = { "npm", "run", "--silent", "tsc", "--", "--pretty", "false" }
    elseif p[1] == "yarn" then
      cmd = { "yarn", "-s", "tsc", "--pretty", "false" }
    elseif p[1] == "pnpm" then
      cmd = { "pnpm", "-s", "tsc", "--pretty", "false" }
    else
      cmd = { "bun", "tsc", "--pretty", "false" }
    end

    return {
      cwd = root,
      cmd = cmd,
      components = {
        qf(),
        { "on_output_parse", problem_matcher = "$tsc" },
        "default",
      },
    }
  end,
  condition = { filetype = { "typescript", "typescriptreact", "javascript", "javascriptreact" } },
}

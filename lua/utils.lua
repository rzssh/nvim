local M = {}

M.workspace_root = function()
  return vim.fs.root(0, { ".git" }) or vim.uv.cwd()
end

M.create_input_cmd_visual_callback = function(cmd)
  return function()
    local mode = vim.api.nvim_get_mode().mode
    local start_line, end_line

    if mode == "v" or mode == "V" then
      start_line = vim.fn.line("'<")
      end_line = vim.fn.line("'>")
    end

    vim.ui.input({ prompt = cmd .. " : " }, function(input)
      if not input or input == "" then
        return
      end

      if start_line and end_line then
        vim.cmd(string.format("%d,%d%s %s", start_line, end_line, cmd, input))
      else
        vim.cmd(cmd .. " " .. input)
      end
    end)
  end
end

M.check_arg = function(arg)
  -- local args = vim.fn.argv()
  local cmd = vim.v.argv

  local found = false
  for _, a in ipairs(cmd) do
    if a == arg then
      found = true
      break
    end
  end

  return found
end

M.mirror_keys = function(aliases)
  local function replace_lhs(lhs)
    if type(lhs) ~= "string" or vim.startswith(lhs, "<Plug>") then return end
    for from, to in pairs(aliases) do
      if lhs == from then return to end
      if vim.endswith(lhs, from) then
        local prefix = lhs:sub(1, #lhs - #from)
        if not vim.endswith(prefix, "-") then
          return prefix .. to
        end
      end
    end
  end

  local fns = {
    { obj = vim.api, name = "nvim_buf_set_keymap", lhs_pos = 3 },
    { obj = vim.api, name = "nvim_set_keymap", lhs_pos = 2 },
    { obj = vim.keymap, name = "set", lhs_pos = 2 },
  }

  for _, fn in ipairs(fns) do
    local orig = fn.obj[fn.name]
    fn.obj[fn.name] = function(...)
      orig(...)
      local args = { ... }
      local new_lhs = replace_lhs(args[fn.lhs_pos])
      if new_lhs then
        args[fn.lhs_pos] = new_lhs
        orig(unpack(args))
      end
    end
  end
end

return M

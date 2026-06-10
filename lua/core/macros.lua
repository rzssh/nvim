local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

local function set_log_macro(filetype)
  local macro_string = nil

  if
    filetype == "javascript"
    or filetype == "typescript"
    or filetype == "javascriptreact"
    or filetype == "typescriptreact"
  then
    macro_string = "yoconsole.log('" .. esc .. "pa: ', " .. esc .. "pa);" .. esc
  elseif filetype == "lua" then
    macro_string = "yoprint(vim.inspect(" .. esc .. "pa))" .. esc
  elseif filetype == "go" then
    macro_string = "yofmt.Println(" .. esc .. "pa)" .. esc
  elseif filetype == "python" then
    macro_string = "yoprint(" .. esc .. "pa)" .. esc
  elseif filetype == "rust" then
    macro_string = "yoprintln!(" .. esc .. "pa);" .. esc
  elseif filetype == "zig" then
    macro_string = [[yo@import("std").debug.print("]]
      .. esc
      .. [[pa = {}\n", .{]]
      .. esc
      .. [[pa});]]
      .. esc
  end
  if macro_string then
    vim.fn.setreg("l", macro_string)
  end
end

-- Set macro register each time buffer changes
-- Allows using the same keybinding for all languages
autocmd("BufEnter", {
  group = augroup("LogMacroBufEnter", { clear = true }),
  callback = function()
    set_log_macro(vim.bo.filetype)
  end,
})

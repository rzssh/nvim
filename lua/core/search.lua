local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local ns = vim.api.nvim_create_namespace("search_hl")
local searching = false

local function set_searching()
  searching = true
  vim.schedule(function()
    searching = false
  end)
end

local function visual_star()
  local view = vim.fn.winsaveview()
  vim.cmd('normal! "xy')
  vim.fn.setreg("/", "\\V" .. vim.fn.escape(vim.fn.getreg("x"), "\\"))
  vim.fn.winrestview(view)
  vim.opt.hlsearch = true
end

vim.on_key(function(char)
  local key, mode = vim.fn.keytrans(char), vim.fn.mode()
  if mode == "n" and vim.tbl_contains({ "n", "N", "*", "#" }, key) then
    set_searching()
    vim.opt.hlsearch = true
  elseif mode == "c" and key == "<CR>" and vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype()) then
    set_searching()
  end
end, ns)

autocmd("OptionSet", {
  pattern = "hlsearch",
  callback = function()
    if vim.v.option_new then
      set_searching()
    end
  end,
})

autocmd("CmdlineEnter", {
  callback = function()
    if vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype()) then
      vim.opt.hlsearch = false
    end
  end,
})

autocmd("CmdlineChanged", {
  callback = function()
    if vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype()) then
      vim.opt.hlsearch = true
    end
  end,
})

autocmd({ "CursorMoved", "InsertEnter" }, {
  callback = function()
    if not searching then
      vim.opt.hlsearch = false
    end
  end,
})

map("n", "*", "*``zz")
map("n", "#", "#``zz")
map("n", "g*", "g*``zz")
map("n", "g#", "g#``zz")
map("x", "*", visual_star)
map("x", "#", visual_star)
map("x", "g*", visual_star)
map("x", "g#", visual_star)
map({ "n", "x" }, "n", "nzz")
map({ "n", "x" }, "N", "Nzz")

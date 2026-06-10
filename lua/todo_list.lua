local api = vim.api

local M = {}
local state = { win_id = nil, augroup = nil, buffers = {} }

local function get_float_config()
  local width = math.min(math.floor(vim.o.columns * 0.8), 100)
  local height = math.floor(vim.o.lines * 0.8)
  return {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = 2,
    border = "single",
    title = " Notes ",
  }
end

local function close_window()
  for buf in pairs(state.buffers) do
    if api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
      api.nvim_buf_call(buf, function()
        vim.cmd.write()
      end)
    end
  end
  if state.win_id and api.nvim_win_is_valid(state.win_id) then
    api.nvim_win_close(state.win_id, true)
  end
  if state.augroup then
    pcall(api.nvim_del_augroup_by_id, state.augroup)
  end
  state.win_id = nil
  state.augroup = nil
  state.buffers = {}
end

local function set_close_keymap()
  vim.keymap.set("n", "q", close_window, { buffer = 0, silent = true, desc = "Close Notes" })
end

local function open_window(filepath)
  local buf = vim.fn.bufadd(filepath)
  vim.bo[buf].buflisted = false

  state.win_id = api.nvim_open_win(buf, true, get_float_config())
  vim.cmd.edit(vim.fn.fnameescape(filepath))
  state.augroup = api.nvim_create_augroup("TodoWindow", { clear = true })

  state.buffers[buf] = true
  set_close_keymap()

  api.nvim_create_autocmd("BufEnter", {
    group = state.augroup,
    callback = function()
      if api.nvim_get_current_win() == state.win_id then
        state.buffers[api.nvim_get_current_buf()] = true
        set_close_keymap()
      end
    end,
  })

  api.nvim_create_autocmd("WinClosed", {
    group = state.augroup,
    pattern = tostring(state.win_id),
    callback = close_window,
    once = true,
  })

  api.nvim_create_autocmd("VimResized", {
    group = state.augroup,
    callback = function()
      if state.win_id and api.nvim_win_is_valid(state.win_id) then
        api.nvim_win_set_config(state.win_id, get_float_config())
      end
    end,
  })
end

function M.toggle()
  if state.win_id and api.nvim_win_is_valid(state.win_id) then
    close_window()
  elseif M.filepath then
    open_window(M.filepath)
  else
    vim.notify("Todo: target_file not configured", vim.log.levels.ERROR)
  end
end

function M.setup(opts)
  if not opts or not opts.target_file then
    vim.notify("Todo: 'target_file' option required", vim.log.levels.ERROR)
    return
  end

  local path = vim.fn.expand(opts.target_file)
  if vim.fn.filereadable(path) == 0 then
    vim.notify("Todo: file not readable: " .. path, vim.log.levels.ERROR)
    return
  end

  M.filepath = path
  api.nvim_create_user_command("Td", M.toggle, {})
  vim.keymap.set("n", "<leader>td", M.toggle, { desc = "Toggle Notes", silent = true })
end

return M

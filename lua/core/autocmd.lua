local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Reload the file if it changes externally
autocmd({ "FileChangedShell", "FocusGained" }, {
  pattern = "*",
  callback = function()
    vim.cmd("silent! checktime")
  end,
})

-- Also reload after a short delay when saving.
-- Some external tooling may modify it and the autocmd above won't work.
-- Useful for working with likes of TanStack Router
autocmd("BufWritePost", {
  pattern = "*",
  callback = function()
    -- Delay the reload to allow the external process to modify the file
    vim.defer_fn(function()
      vim.cmd("silent! checktime")
    end, 500)
  end,
})

-- Kill daemons manually until core_d provides this functionality.
autocmd("VimLeavePre", {
  callback = function()
    vim.fn.jobstart("killall prettierd eslint_d", { detach = true })
  end,
})

-- Close windows with q
autocmd("FileType", {
  pattern = {
    "help",
    "man",
    "qf",
    "lspinfo",
    "git",
    "copilot",
    "grug-far",
    "vim",
    "fugitive",
    -- "codecompanion"
  },
  callback = function()
    vim.bo.buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", "<cmd>quit<CR>", { buffer = true, silent = true })
    end)
  end,
})

-- Window layout
autocmd("FileType", {
  pattern = { "help", "qf", "copilot", "vim" },
  callback = function()
    -- Move to bottom (hJkl)
    -- vim.cmd("wincmd J")
    vim.cmd("horizontal resize 14")
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("HighlightOnYank", { clear = true }),
  pattern = "*",
  desc = "Highlight text when yank",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Alternative for dropbar.nvim plugin that I use
-- Displays the file path in the winbar, with certain exceptions
-- vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
--   callback = function()
--     local empty_for = {
--       "oil",
--       "NvimTree",
--       "fugitiveblame",
--     }
--     local disable_for = {
--       "help",
--       "qf",
--       "netrw",
--       "Trouble",
--       "neo-tree",
--       "nofile",
--       "snacks_picker_input",
--       "snacks_picker_list",
--       "snacks_picker_preview",
--     }
--     local ft = vim.bo.filetype
--     local bt = vim.bo.buftype
--
--     if vim.tbl_contains(disable_for, ft) then
--       vim.wo.winbar = ""
--       return
--     elseif vim.tbl_contains(empty_for, ft) or bt ~= "" then
--       vim.wo.winbar = " "
--     else
--       vim.wo.winbar = "%f"
--     end
--   end,
-- })

-- Disable extending comments on new lines.
-- autocmd("BufEnter", {
--   pattern = "*",
--   desc = "Disable auto comment",
--   callback = function()
--     vim.opt.formatoptions:remove({ "c", "r", "o" })
--   end,
-- })

local map = vim.keymap.set

local M = {}

M.plugin = {
  "nvim-mini/mini.nvim",
  event = "LazyFile",
  config = function()
    local mini_align = require("mini.align")
    local mini_bracketed = require("mini.bracketed")
    local mini_ai = require("mini.ai")
    local mini_surround = require("mini.surround")
    local mini_splitjoin = require("mini.splitjoin")
    local mini_cursorword = require("mini.cursorword")
    local mini_diff = require("mini.diff")
    local mini_move = require("mini.move")
    local mini_jump = require("mini.jump")

    mini_align.setup()
    mini_surround.setup({ n_lines = 9999 })
    mini_splitjoin.setup()
    mini_cursorword.setup()
    mini_jump.setup()

    mini_diff.setup({
      view = { style = "sign" },
    })
    map("n", "<leader>=", function()
      mini_diff.toggle_overlay(0)
    end, { desc = "Toggle diff overlay" })
    map("n", "<leader>ga", function()
      MiniDiff.do_hunks(0, "apply")
    end, { desc = "Apply hunk (stage)" })
    map("n", "<leader>gr", function()
      MiniDiff.do_hunks(0, "reset")
    end, { desc = "Discard hunk" })
    map("x", "<leader>ga", function()
      MiniDiff.do_hunks(0, "apply", { selection = true })
    end, { desc = "Apply selected lines" })

    mini_move.setup({
      mappings = {
        left = "H",
        down = "J",
        up = "K",
        right = "L",
      },
    })

    mini_ai.setup({
      n_lines = 9999,
      custom_textobjects = {
        ["|"] = mini_ai.gen_spec.pair("|", "|", { type = "balanced" }),
      },
    })

    mini_bracketed.setup({
      treesitter = { suffix = "" },
      diagnostic = { options = { float = false } },
    })
    vim.keymap.set("n", "u", function()
      vim.cmd("silent! undo")
      MiniBracketed.register_undo_state()
    end)
    vim.keymap.set("n", "<C-r>", function()
      vim.cmd("silent! redo")
      MiniBracketed.register_undo_state()
    end)
  end,
}

M.icons = {
  eslint = { glyph = "󰱺", hl = "MiniIconsPurple" },
  prettier = { glyph = "", hl = "MiniIconsPurple" },
  node = { glyph = "", hl = "MiniIconsGreen" },
  npm = { glyph = "", hl = "MiniIconsRed" },
  yarn = { glyph = "", hl = "MiniIconsBlue" },
  pnpm = { glyph = "", hl = "MiniIconsOrange" },
  tsconfig_json = { glyph = "", hl = "MiniIconsAzure" },
  env = { glyph = "", hl = "MiniIconsWhite" },
  vite = { glyph = "", hl = "MiniIconsPurple" },
  vitest = { glyph = "", hl = "MiniIconsYellow" },
  playwright = { glyph = "", hl = "MiniIconsCyan" },
  postcss = { glyph = "", hl = "MiniIconsRed" },
  tailwind = { glyph = "", hl = "MiniIconsAzure" },
}

M.file_icon_config = {
  [".eslintignore"] = M.icons.eslint,
  [".eslintrc.js"] = M.icons.eslint,
  [".eslintrc.cjs"] = M.icons.eslint,
  [".eslintrc.mjs"] = M.icons.eslint,

  ["eslint.config.js"] = M.icons.eslint,
  ["eslint.config.cjs"] = M.icons.eslint,
  ["eslint.config.mjs"] = M.icons.eslint,

  [".prettierignore"] = M.icons.prettier,
  [".prettierrc"] = M.icons.prettier,
  [".prettierrc.js"] = M.icons.prettier,
  [".prettierrc.cjs"] = M.icons.prettier,
  [".prettierrc.mjs"] = M.icons.prettier,

  ["prettier.config.js"] = M.icons.prettier,
  ["prettier.config.cjs"] = M.icons.prettier,
  ["prettier.config.mjs"] = M.icons.prettier,

  [".npmrc"] = M.icons.npm,
  [".node-version"] = M.icons.node,
  [".nvmrc"] = M.icons.node,
  ["package.json"] = M.icons.node,

  [".yarnrc.yml"] = M.icons.yarn,
  ["yarn.lock"] = M.icons.yarn,

  ["pnpm-lock.yaml"] = M.icons.pnpm,
  ["pnpm-workspace.yaml"] = M.icons.pnpm,

  ["tsconfig.json"] = M.icons.tsconfig_json,
  ["tsconfig.build.json"] = M.icons.tsconfig_json,

  [".env"] = M.icons.env,
  [".env.example"] = M.icons.env,
  [".env.development"] = M.icons.env,
  [".env.test"] = M.icons.env,
  [".env.production"] = M.icons.env,

  ["vite.config.ts"] = M.icons.vite,
  ["vite.config.js"] = M.icons.vite,

  ["vitest.config.ts"] = M.icons.vite,
  ["vitest.config.js"] = M.icons.vite,

  ["playwright.config.ts"] = M.icons.playwright,
  ["playwright.config.js"] = M.icons.playwright,

  ["postcss.config.js"] = M.icons.postcss,
  ["postcss.config.ts"] = M.icons.postcss,
  ["postcss.config.mjs"] = M.icons.postcss,
  ["postcss.config.cjs"] = M.icons.postcss,
  ["postcss.config.mts"] = M.icons.postcss,
  ["postcss.config.cts"] = M.icons.postcss,

  ["tailwind.config.js"] = M.icons.tailwind,
  ["tailwind.config.ts"] = M.icons.tailwind,
  ["tailwind.config.mjs"] = M.icons.tailwind,
  ["tailwind.config.cjs"] = M.icons.tailwind,
  ["tailwind.config.mts"] = M.icons.tailwind,
  ["tailwind.config.cts"] = M.icons.tailwind,
}

M.open_notifications_history = function(notifications)
  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " Notification History ",
    title_pos = "center",
  })

  local lines = {}
  for _, notif in ipairs(notifications) do
    local msg = type(notif.msg) == "string" and notif.msg or vim.inspect(notif.msg)
    msg = msg:gsub("%%", "%%%%") -- Escape literal '%'
    msg = msg:gsub("\n", " ") -- Replace newlines with spaces
    table.insert(lines, string.format("[%s] %s", notif.level, msg))
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "log"
  vim.bo[buf].bufhidden = "wipe"

  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true, nowait = true, desc = "Close notification history" })
end

return M.plugin

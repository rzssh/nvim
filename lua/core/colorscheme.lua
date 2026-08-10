local M = {}

local function hex_to_rgb(hex)
  return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

local function int_to_rgb(c)
  return bit.rshift(bit.band(c, 0xFF0000), 16),
    bit.rshift(bit.band(c, 0x00FF00), 8),
    bit.band(c, 0x0000FF)
end

local function rgb_to_hex(r, g, b)
  return string.format(
    "#%02x%02x%02x",
    math.min(255, math.max(0, math.floor(r))),
    math.min(255, math.max(0, math.floor(g))),
    math.min(255, math.max(0, math.floor(b)))
  )
end

local function lighten(hex, amount)
  local r, g, b = hex_to_rgb(hex)
  return rgb_to_hex(r + (255 - r) * amount, g + (255 - g) * amount, b + (255 - b) * amount)
end

local function blend_int(fg_int, bg_int, alpha)
  local fr, fg, fb = int_to_rgb(fg_int)
  local br, bg, bb = int_to_rgb(bg_int)
  return rgb_to_hex(
    fr * alpha + br * (1 - alpha),
    fg * alpha + bg * (1 - alpha),
    fb * alpha + bb * (1 - alpha)
  )
end

local function transparent_winbar()
  vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
end

local function transparent_float()
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatTitle", { bg = "NONE" })
end

local function transparent_neotree()
  vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { bg = "NONE" })
end

local function transparent_statusline()
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
end

local function default_harpoon()
  vim.api.nvim_set_hl(0, "HarpoonOptionHL", { fg = "#89DDFF" })
  vim.api.nvim_set_hl(0, "HarpoonSelectedOptionHL", { fg = "#5DE4C7" })
end

local function minicursorword()
  local cl = vim.api.nvim_get_hl(0, { name = "CursorLine" })
  local func = vim.api.nvim_get_hl(0, { name = "Function" })
  if not cl.bg or not func.fg then
    return
  end
  local word_bg = blend_int(func.fg, cl.bg, 0.25)
  vim.api.nvim_set_hl(0, "MiniCursorword", { bg = word_bg })
  vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = word_bg })
end

local function ts_context()
  vim.api.nvim_set_hl(
    0,
    "TreesitterContext",
    { bg = vim.api.nvim_get_hl(0, { name = "CursorLine" }).bg }
  )
  vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = false })
end

local function flash_search()
  vim.api.nvim_set_hl(0, "FlashCurrent", { link = "CurSearch" })
  vim.api.nvim_set_hl(0, "FlashMatch", { link = "Search" })
end

local function mini_diff_overlay()
  vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { bg = "#1e3a2f", fg = "#a6e3a1" })
  vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { bg = "#3a1e1e", fg = "#f38ba8" })
  vim.api.nvim_set_hl(0, "MiniDiffOverChange", { bg = "#3a351e", fg = "#f9e2af" })
  vim.api.nvim_set_hl(0, "MiniDiffOverContext", { fg = "#6c7086" })
end

local function diagnostics()
  local diagnostic_underline = vim.api.nvim_get_hl(0, { name = "DiagnosticUnderline" })
  diagnostic_underline.underline = true
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", diagnostic_underline)
end

---@param disable? boolean If true, removes bold styling from selected nodes instead
local function ts_lsp_bold_nodes(disable)
  local nodes = {
    "@lsp.type.function",
    "@function",
    "Function",
    "Green",
  }
  for _, node in ipairs(nodes) do
    vim.api.nvim_set_hl(
      0,
      node,
      vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = node }), { bold = not disable })
    )
  end
end

M.matugen_data = nil
M._matugen_raw = nil

local function read_colors()
  local file = io.open(vim.fn.expand("~/.cache/matugen/colors.json"), "r")
  if not file then
    return nil
  end
  local content = file:read("*all")
  file:close()
  return content
end

local function load_matugen_data()
  local content = read_colors()
  if not content then
    vim.notify("matugen: No colors at ~/.cache/matugen/colors.json", vim.log.levels.WARN)
    return nil
  end

  local ok, data = pcall(vim.json.decode, content)
  if not ok or not data then
    return nil
  end
  M._matugen_raw = content
  M.matugen_data = data
  return data
end

local function apply_matugen(variant)
  variant = variant or "ansi"
  local data = load_matugen_data()
  if not data then
    return false
  end

  local bg = data.special.background
  local fg = data.special.foreground
  local c = data.colors
  local accent = data.special.cursor or c.color4
  local m = data.material or {}
  local pri = m.primary or accent
  local sec = m.secondary or c.color6
  local ter = m.tertiary or c.color5
  local selection_bg = m.primary_container or c.color0
  local selection_fg = m.on_primary_container or fg
  local syn = variant == "rich"
      and {
        kw = pri,
        fn = accent,
        str = c.color2,
        typ = sec,
        const = ter,
        spec = c.color6,
        op = c.color7,
        num = c.color5,
      }
    or {
      kw = c.color1,
      fn = accent,
      str = c.color2,
      typ = c.color3,
      const = c.color5,
      spec = c.color6,
      op = c.color6,
      num = c.color5,
    }
  local subtle = lighten(bg, 0.1)

  require("mini.base16").setup({
    palette = {
      base00 = bg,
      base01 = subtle,
      base02 = selection_bg,
      base03 = c.color8,
      base04 = c.color7,
      base05 = fg,
      base06 = c.color15 or fg,
      base07 = selection_fg,
      base08 = c.color1,
      base09 = syn.const,
      base0A = syn.typ,
      base0B = syn.str,
      base0C = syn.spec,
      base0D = syn.fn,
      base0E = syn.kw,
      base0F = ter,
    },
    plugins = {
      default = false,
      ["nvim-mini/mini.nvim"] = true,
      ["anuvyklack/hydra.nvim"] = true,
      ["folke/lazy.nvim"] = true,
      ["folke/which-key.nvim"] = true,
      ["OXY2DEV/markview.nvim"] = true,
      ["saghen/blink.cmp"] = true,
    },
  })
  vim.g.colors_name = "matugen"
  vim.o.background = "dark"

  local highlights = {
    Normal = { fg = fg, bg = "NONE" },
    NormalNC = { fg = fg, bg = "NONE" },
    Visual = { fg = selection_fg, bg = selection_bg },
    LineNr = { fg = c.color8 },
    CursorLineNr = { fg = accent, bold = true },
    Search = { fg = bg, bg = c.color3 },
    IncSearch = { fg = bg, bg = c.color5 },
    Comment = { fg = c.color8, italic = true },
    Function = { fg = syn.fn, bold = true },
    Statement = { fg = syn.kw },
    Number = { fg = syn.num },
    Boolean = { fg = syn.num },
    Identifier = { fg = fg },
    Operator = { fg = syn.op },
    Pmenu = { fg = fg, bg = c.color0 },
    PmenuSel = { fg = selection_fg, bg = selection_bg, bold = true },
    PmenuSbar = { bg = c.color0 },
    PmenuThumb = { bg = c.color8 },
    Title = { fg = accent, bold = true },
    MatchParen = { fg = c.color3, bold = true },
    WinSeparator = { fg = c.color8 },
    WarningMsg = { fg = c.color3 },
    SignColumn = { bg = "NONE" },
    FoldColumn = { fg = c.color8, bg = "NONE" },
    Whitespace = { fg = subtle },
    EndOfBuffer = { fg = bg },
    QuickFixLine = { fg = selection_fg, bg = selection_bg, bold = true },
    Error = { fg = c.color1 },
    Substitute = { fg = bg, bg = c.color5 },
    SpellBad = { sp = c.color1, undercurl = true },
    SpellCap = { sp = c.color3, undercurl = true },
    SpellRare = { sp = c.color6, undercurl = true },
    SpellLocal = { sp = c.color2, undercurl = true },
    DiagnosticUnderlineError = { sp = c.color1, undercurl = true },
    DiagnosticUnderlineWarn = { sp = c.color3, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.color4, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.color6, undercurl = true },
    DiagnosticVirtualTextError = { fg = c.color1, bg = "NONE" },
    DiagnosticVirtualTextWarn = { fg = c.color3, bg = "NONE" },
    DiagnosticVirtualTextInfo = { fg = c.color4, bg = "NONE" },
    DiagnosticVirtualTextHint = { fg = c.color6, bg = "NONE" },
    LspInlayHint = { fg = c.color8, bg = "NONE", italic = true },
    LspReferenceText = { bg = subtle },
    LspReferenceRead = { bg = subtle },
    LspReferenceWrite = { bg = subtle, bold = true },
    FlashLabel = { fg = bg, bg = c.color5, bold = true },
    FlashBackdrop = { fg = c.color8 },
    DropBarMenuCurrentContext = { bg = subtle },
    DropBarMenuHoverEntry = { fg = selection_fg, bg = selection_bg },
  }
  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end

  local links = {
    LineNrAbove = "LineNr",
    LineNrBelow = "LineNr",
    DiagnosticFloatingError = "DiagnosticError",
    DiagnosticFloatingWarn = "DiagnosticWarn",
    DiagnosticFloatingInfo = "DiagnosticInfo",
    DiagnosticFloatingHint = "DiagnosticHint",
    DiagnosticFloatingOk = "DiagnosticOk",
    DiagnosticSignError = "DiagnosticError",
    DiagnosticSignWarn = "DiagnosticWarn",
    DiagnosticSignInfo = "DiagnosticInfo",
    DiagnosticSignHint = "DiagnosticHint",
    DiagnosticSignOk = "DiagnosticOk",
    ["@variable"] = "Identifier",
    ["@variable.builtin"] = "Statement",
    ["@variable.parameter"] = "Identifier",
    ["@variable.member"] = "Special",
    ["@property"] = "Special",
    ["@field"] = "Special",
    ["@function.call"] = "Function",
    ["@function.builtin"] = "Function",
    ["@function.method"] = "Function",
    ["@function.method.call"] = "Function",
    ["@constructor"] = "Type",
    ["@parameter"] = "Identifier",
    ["@keyword.function"] = "Keyword",
    ["@keyword.return"] = "Keyword",
    ["@conditional"] = "Keyword",
    ["@repeat"] = "Keyword",
    ["@string.escape"] = "Special",
    ["@constant.builtin"] = "Constant",
    ["@type.builtin"] = "Type",
    ["@punctuation"] = "Identifier",
    ["@punctuation.bracket"] = "Identifier",
    ["@punctuation.delimiter"] = "Identifier",
    ["@punctuation.special"] = "Special",
    ["@tag"] = "Keyword",
    ["@tag.attribute"] = "Function",
    ["@tag.delimiter"] = "Identifier",
    ["@namespace"] = "Type",
    ["@module"] = "Type",
  }
  for from, to in pairs(links) do
    vim.api.nvim_set_hl(0, from, { link = to })
  end

  return true
end

M.themes = {
  {
    name = "System (matugen)",
    colorscheme = "matugen",
    custom_apply = function()
      return apply_matugen("ansi")
    end,
    after = function()
      transparent_winbar()
      transparent_float()
      transparent_neotree()
    end,
  },
  {
    name = "System (rich)",
    colorscheme = "matugen",
    custom_apply = function()
      return apply_matugen("rich")
    end,
    after = function()
      transparent_winbar()
      transparent_float()
      transparent_neotree()
    end,
  },
}

vim.g.THEME = vim.g.THEME or "System (matugen)"

function M.get_theme(name)
  for _, theme in ipairs(M.themes) do
    if theme.name == name then
      return theme
    end
  end
  return nil
end

function M.apply(name)
  local theme = M.get_theme(name)
  if not theme then
    return false
  end

  vim.g.THEME = name

  local ok
  if theme.custom_apply then
    ok = theme.custom_apply()
  else
    ok = pcall(vim.cmd.colorscheme, theme.colorscheme)
  end

  if ok then
    if theme.after then
      theme.after()
    end

    minicursorword()
    ts_context()
    mini_diff_overlay()
    flash_search()
    ts_lsp_bold_nodes()
    default_harpoon()
    transparent_statusline()
    diagnostics()

    if theme.custom_apply then
      vim.cmd("doautocmd ColorScheme " .. (theme.colorscheme or ""))
    end

    if theme.colorscheme == "matugen" then
      vim.schedule(function()
        if vim.g.colors_name ~= "matugen" then
          return
        end
        local hi = vim.api.nvim_set_hl
        hi(0, "DiagnosticError", { fg = "#f38ba8" })
        hi(0, "DiagnosticWarn", { fg = "#f9e2af" })
        hi(0, "DiagnosticInfo", { fg = "#89b4fa" })
        hi(0, "DiagnosticHint", { fg = "#a6e3a1" })
        hi(0, "GitSignsAdd", { fg = "#a6e3a1" })
        hi(0, "GitSignsChange", { fg = "#f9e2af" })
        hi(0, "GitSignsDelete", { fg = "#f38ba8" })
        hi(0, "DiffAdd", { fg = "#a6e3a1", bg = "NONE" })
        hi(0, "DiffChange", { fg = "#f9e2af", bg = "NONE" })
        hi(0, "DiffDelete", { fg = "#f38ba8", bg = "NONE" })
        hi(0, "llama_hl_fim_hint", { link = "Comment" })
        transparent_statusline()
      end)
    end
  end
  return ok
end

local group = vim.api.nvim_create_augroup("CoreColorscheme", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  nested = true,
  callback = function()
    M.apply(vim.g.THEME)
  end,
})

local function refresh_matugen()
  if not tostring(vim.g.THEME):match("^System %(") then
    return
  end
  local content = read_colors()
  if not content or #content == 0 or content == M._matugen_raw then
    return
  end
  M.apply(vim.g.THEME)
end

vim.api.nvim_create_autocmd("FocusGained", {
  group = group,
  callback = refresh_matugen,
})

function M.pick()
  local prev = vim.g.THEME
  local confirmed = false

  local items = {}
  local current_theme_item = nil

  for _, theme in ipairs(M.themes) do
    if theme.name == vim.g.THEME then
      current_theme_item = { text = theme.name, theme = theme }
      table.insert(items, current_theme_item)
      break
    end
  end

  for _, theme in ipairs(M.themes) do
    if theme.name ~= vim.g.THEME then
      table.insert(items, { text = theme.name, theme = theme })
    end
  end

  Snacks.picker.pick({
    title = "Colorschemes",
    items = items,
    preview = nil,
    layout = {
      preset = "select",
      layout = {
        height = #M.themes + 2,
        width = 20,
        min_width = 20,
      },
    },
    format = function(item)
      return { { item.theme.name } }
    end,
    confirm = function(picker, item)
      confirmed = true
      if item then
        M.apply(item.theme.name)
      end
      picker:close()
    end,
    on_show = function()
      vim.cmd.stopinsert()
    end,
    on_change = function(_, item)
      if item then
        M.apply(item.theme.name)
      end
    end,
    on_close = function()
      if not confirmed then
        M.apply(prev)
      end
    end,
  })
end

vim.keymap.set("n", "<leader>uc", M.pick, { desc = "Colorscheme picker" })

local matugen_watcher = vim.uv.new_fs_event()
if matugen_watcher then
  matugen_watcher:start(
    vim.fn.expand("~/.cache/matugen"),
    {},
    vim.schedule_wrap(function(err, fname)
      if err or fname ~= "colors.json" then
        return
      end
      refresh_matugen()
    end)
  )
end

return M

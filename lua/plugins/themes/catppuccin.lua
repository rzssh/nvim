return {
  "catppuccin/nvim",
  name = "catppuccin",
  opts = {
    flavour = "mocha",
    auto_integrations = true,
    transparent_background = true,
    no_italic = true,
    integrations = {
      noice = true,
      notify = true,
      which_key = true,
      mini = {
        enabled = true,
        indentscope_color = "sky",
      },
    },
    color_overrides = {
      mocha = {},
    },
    custom_highlights = function(colors)
      return {
        -- Comment = { fg = colors.sky },
        DiagnosticUnnecessary = { fg = colors.surface2, bg = colors.crust, underline = true },

        BlinkCmpLabel = { fg = colors.subtext1 },
        BlinkCmpLabelMatch = { fg = colors.mauve }, -- colors.flamingo colors.teal

        HarpoonOptionHL = { fg = colors.text },
        HarpoonSelectedOptionHL = { fg = colors.green },

        CodeCompanionChatTool = { fg = colors.teal },
        CodeCompanionChatVariable = { fg = colors.teal },

        MiniCursorword = { bg = colors.surface2, style = {} },
        MiniCursorwordCurrent = { bg = colors.surface2, style = {} },

        LineNr = { fg = colors.surface2 },
        CursorLineNr = { fg = colors.blue },
        CursorLine = { bg = colors.surface0 },
      }
    end,
  },
}

--  Catppuccin Mocha
-- 	rosewater = "#f5e0dc"
-- 	flamingo  = "#f2cdcd"
-- 	pink      = "#f5c2e7"
-- 	mauve     = "#cba6f7"
-- 	red       = "#f38ba8"
-- 	maroon    = "#eba0ac"
-- 	peach     = "#fab387"
-- 	yellow    = "#f9e2af"
-- 	green     = "#a6e3a1"
-- 	teal      = "#94e2d5"
-- 	sky       = "#89dceb"
-- 	sapphire  = "#74c7ec"
-- 	blue      = "#89b4fa"
-- 	lavender  = "#b4befe"
-- 	text      = "#cdd6f4"
-- 	subtext1  = "#bac2de"
-- 	subtext0  = "#a6adc8"
-- 	overlay2  = "#9399b2"
-- 	overlay1  = "#7f849c"
-- 	overlay0  = "#6c7086"
-- 	surface2  = "#585b70"
-- 	surface1  = "#45475a"
-- 	surface0  = "#313244"
-- 	base      = "#1e1e2e"
-- 	mantle    = "#181825"
-- 	crust     = "#11111b"

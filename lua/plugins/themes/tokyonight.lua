return {
  "folke/tokyonight.nvim",
  opts = {
    transparent = true,
    style = "night",
    on_colors = function(colors)
      local bg = "#011628"
      local bg_dark = "#011423"
      local bg_highlight = "#143652"
      local bg_search = "#0A64AC"
      local bg_visual = "#275378"
      local fg = "#CBE0F0"
      local fg_dark = "#B4D0E9"
      local fg_gutter = "#627E97"
      local border = "#547998"

      colors.bg = bg
      colors.bg_dark = bg_dark
      colors.bg_float = bg_dark
      colors.bg_highlight = bg_highlight
      colors.bg_popup = bg_dark
      colors.bg_search = bg_search
      colors.bg_sidebar = bg_dark
      colors.bg_statusline = bg_dark
      colors.bg_visual = bg_visual
      colors.border = border
      colors.fg = fg
      colors.fg_dark = fg_dark
      colors.fg_float = fg
      colors.fg_gutter = fg_gutter
      colors.fg_sidebar = fg_dark
    end,
    on_highlights = function(hl, colors)
      local comments = "#4682B4"
      hl.Comment = { fg = comments }

      local bg_diagnostic_unnecessary = "#011423"
      local fg_diagnostic_unnecessary = "#627E97"
      hl.DiagnosticUnnecessary = { fg = fg_diagnostic_unnecessary, bg = bg_diagnostic_unnecessary }

      local cursor_word_hl = "#506477"
      hl.MiniCursorword = { bg = cursor_word_hl }
      hl.MiniCursorwordCurrent = { bg = cursor_word_hl }

      hl.AugmentSuggestionHighlight = { fg = colors.blue1 }

      hl.CopilotSuggestion = { fg = colors.fg_dark }
      hl.CopilotAnnotation = { fg = colors.fg_dark }

      hl.SnacksPickerInputBorder = { bg = "NONE" }
    end,
  },
}

-- Tokyonight palette
-- bg = "#24283b",
-- bg_dark = "#1f2335",
-- bg_dark1 = "#1b1e2d",
-- bg_highlight = "#292e42",
-- blue = "#7aa2f7",
-- blue0 = "#3d59a1",
-- blue1 = "#2ac3de",
-- blue2 = "#0db9d7",
-- blue5 = "#89ddff",
-- blue6 = "#b4f9f8",
-- blue7 = "#394b70",
-- comment = "#565f89",
-- cyan = "#7dcfff",
-- dark3 = "#545c7e",
-- dark5 = "#737aa2",
-- fg = "#c0caf5",
-- fg_dark = "#a9b1d6",
-- fg_gutter = "#3b4261",
-- green = "#9ece6a",
-- green1 = "#73daca",
-- green2 = "#41a6b5",
-- magenta = "#bb9af7",
-- magenta2 = "#ff007c",
-- orange = "#ff9e64",
-- purple = "#9d7cd8",
-- red = "#f7768e",
-- red1 = "#db4b4b",
-- teal = "#1abc9c",
-- terminal_black = "#414868",
-- yellow = "#e0af68",
-- git = {
--   add = "#449dab",
--   change = "#6183bb",
--   delete = "#914c54",
-- }

-- Poimanres theme palette
-- https://github.com/olivercederborg/poimandres.nvim/blob/main/lua/poimandres/palette.lua

-- yellow         = '#FFFAC2',
-- teal1          = '#5DE4C7',
-- teal2          = '#5FB3A1',
-- teal3          = '#42675A',
-- blue1          = '#89DDFF',
-- blue2          = '#ADD7FF',
-- blue3          = '#91B4D5',
-- blue4          = '#7390AA',
-- pink1          = '#FAE4FC',
-- pink2          = '#FCC5E9',
-- pink3          = '#D0679D',
-- blueGray1      = '#A6ACCD',
-- blueGray2      = '#767C9D',
-- blueGray3      = '#506477',
-- background1    = '#303340',
-- background2    = '#1B1E28',
-- background3    = '#171922',
-- text           = '#E4F0FB',
-- white          = '#FFFFFF',
-- none           = 'NONE',
-- darkGray       = '#A9A9A9',
-- steelBlue      = '#4682B4',
-- lightSteelBlue = '#B0C4DE',
-- slatePurple    = '#6A5ACD',

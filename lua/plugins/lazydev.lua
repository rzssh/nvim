return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "snacks.nvim", words = { "Snacks" } },
      { path = "mini.nvim", words = { "Mini" } },
      { path = "oklch-color-picker.nvim", words = { "oklch" } },
      { path = "wezterm-types", mods = { "wezterm" } },
      { path = "yazi.nvim", words = { "YaziConfig" } },
    },
  },
}

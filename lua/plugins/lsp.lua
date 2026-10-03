local servers = {
  -- "vtsls",
  -- "ts_ls",
  "tsgo",
  "biome",
  "eslint",
  "tailwindcss",
  "prismals",
  "graphql",
  "astro",
  "svelte",

  "html",
  "cssls",

  "marksman",
  "jsonls",
  "yamlls",
  "fish_lsp",
  "hyprls",

  "pyright",

  "lua_ls",
  "nixd",

  "typos_lsp",
  "tinymist",

  "ols",
  "zls",
  "gopls",
  "bashls",
  "clangd",
}

return {
  {
    "neovim/nvim-lspconfig",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    dependencies = { "b0o/schemastore.nvim" },
    config = function()
      local tailwind_configs = {
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        "theme/static_src/tailwind.config.js",
        "theme/static_src/tailwind.config.cjs",
        "theme/static_src/tailwind.config.mjs",
        "theme/static_src/tailwind.config.ts",
      }

      vim.lsp.config("tailwindcss", {
        root_dir = function(bufnr, on_dir)
          local path = vim.api.nvim_buf_get_name(bufnr)
          local config = vim.fs.find(tailwind_configs, { path = path, upward = true })[1]
          if config then
            on_dir(vim.fs.dirname(config))
            return
          end

          for _, package in
            ipairs(vim.fs.find({ "package.json", "package.json5" }, { path = path, upward = true }))
          do
            local file = io.open(package, "r")
            local contents = file and file:read("*a")
            if file then
              file:close()
            end
            if contents and contents:find("tailwindcss", 1, true) then
              on_dir(vim.fs.dirname(package))
              return
            end
          end
        end,
      })

      for _, name in ipairs(servers) do
        local cfg = vim.lsp.config[name]
        local cmd = cfg and cfg.cmd
        if type(cmd) == "function" or (type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1) then
          vim.lsp.enable(name)
        end
      end
    end,
  },

  {
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
  },

  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
  },
}

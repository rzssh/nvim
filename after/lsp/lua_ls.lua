return {
  settings = {
    Lua = {
      telemetry = { enable = false },
      diagnostics = { disable = { "missing-fields" } },
      hint = { enable = true },
    },
  },
  on_attach = require("lsp_utils").on_attach,
}

return {
  on_attach = function(client, bufnr)
    require("lsp_utils").on_attach(client, bufnr)
  end,
}

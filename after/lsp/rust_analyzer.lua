local map = vim.keymap.set

local function reload_workspace(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })
  for _, client in ipairs(clients) do
    vim.notify("Reloading Cargo Workspace")
    ---@diagnostic disable-next-line:param-type-mismatch
    client:request("rust-analyzer/reloadWorkspace", nil, function(err)
      if err then
        error(tostring(err))
      end
      vim.notify("Cargo workspace reloaded")
    end, 0)
  end
end

return {
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "LspCargoReload", function()
      reload_workspace(bufnr)
    end, { desc = "Reload current cargo workspace" })

    require("lsp_utils").on_attach(client, bufnr)

    map("n", "<leader>ca", function()
      vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
      -- or vim.lsp.buf.codeAction() if you don't want grouping.
    end, { silent = true, buffer = bufnr })

    -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
    map("n", "K", function()
      vim.cmd.RustLsp({ "hover", "actions" })
    end, { silent = true, buffer = bufnr })
  end,
}

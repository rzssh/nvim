local util = require("lsp_utils")
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

return {
  on_attach = function(client, bufnr)
    util.on_attach(client, bufnr)

    autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        if not vim.g.disable_autoformat then
          util.apply_action_sync(client, bufnr, "source.fixAll.biome")
          util.apply_action_sync(client, bufnr, "source.organizeImports.biome")
        end
      end,
    })

    map("n", "<leader>cI", function()
      util.apply_action_sync(client, bufnr, "source.organizeImports.biome")
    end, {
      desc = "Biome: Organize Imports",
      buffer = bufnr,
    })

    local biome_executable = "biome"
    local local_cmd = (client.config or {}).root_dir
      and client.config.root_dir .. "/node_modules/.bin/biome"
    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      biome_executable = local_cmd
    end

    map("n", "<leader>cl", function()
      local cmd =
        { biome_executable, "check", vim.api.nvim_buf_get_name(bufnr), "--fix", "--unsafe" }
      util.execute_system_cmd_and_sync_buf(cmd)
    end, { buffer = bufnr, desc = "Biome: Fix Unsafe" })

    map("n", "<leader>cL", function()
      local cmd = { biome_executable, "check", ".", "--fix", "--unsafe" }
      util.execute_system_cmd_and_sync_buf(cmd)
    end, { buffer = bufnr, desc = "Biome: Fix Unsafe (Workspace)" })
  end,
}

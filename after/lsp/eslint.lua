local util = require("lsp_utils")
local lsp = vim.lsp
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

local diagnostic_err_alerted = false

local eslint_config_files = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  ".eslintrc.json",
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
}

return {
  root_dir = function(bufnr, on_dir)
    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }

    root_markers = { root_markers, { ".git" } }

    if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
      return
    end

    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    local filename = vim.api.nvim_buf_get_name(bufnr)

    local ignored_dirs = {
      -- os.getenv("HOME") .. "/projects/my-ass-job/broken-project",
    }

    for _, dir in ipairs(ignored_dirs) do
      if string.find(filename, dir) then
        -- Don't load ESLint for projects where it is broken
        return nil
      end
    end

    local eslint_config_files_with_package_json =
      util.insert_package_json(eslint_config_files, "eslintConfig", filename)
    local is_buffer_using_eslint = vim.fs.find(eslint_config_files_with_package_json, {
      path = filename,
      type = "file",
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]
    if not is_buffer_using_eslint then
      return
    end

    on_dir(project_root)
  end,
  on_attach = function(client, bufnr)
    util.on_attach(client, bufnr)

    vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
      client:request_sync("workspace/executeCommand", {
        command = "eslint.applyAllFixes",
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = lsp.util.buf_versions[bufnr],
          },
        },
      }, nil, bufnr)
    end, {})

    autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        if not vim.g.disable_autoformat then
          vim.cmd("LspEslintFixAll")
        end
      end,
    })

    map("n", "<leader>cl", vim.cmd.LspEslintFixAll, {
      desc = "Fix all ESLint issues",
      buffer = bufnr,
    })
  end,
  handlers = {
    ["textDocument/diagnostic"] = function(...)
      local data, _, evt, _ = ...

      if data and data.code and data.code < 0 then
        if not diagnostic_err_alerted then
          vim.notify(
            string.format("ESLint failed due to an error: \n%s", data.message),
            vim.log.levels.WARN,
            { title = "ESLint" }
          )
          diagnostic_err_alerted = true
        end

        return
      end

      return vim.lsp.diagnostic.on_diagnostic(...)
    end,
    ["eslint/openDoc"] = function(_, result)
      if result then
        vim.ui.open(result.url)
      end
      return {}
    end,
    ["eslint/confirmESLintExecution"] = function(_, result)
      if not result then
        return
      end
      return 4 -- approved
    end,
    ["eslint/probeFailed"] = function()
      vim.notify("ESLint probe failed.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("Unable to find ESLint library.", vim.log.levels.WARN)
      return {}
    end,
  },
}

local map = vim.keymap.set

local lang_config = {
  preferences = {
    importModuleSpecifier = "non-relative",
  },
  updateImportsOnFileMove = { enabled = "always" },
  suggest = {
    completeFunctionCalls = true,
  },
  inlayHints = {
    enumMemberValues = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = "literals" },
    parameterTypes = { enabled = true },
    propertyDeclarationTypes = { enabled = true },
    variableTypes = { enabled = false },
  },
}

return {
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    ["js/ts"] = { implicitProjectConfig = { checkJs = true } },
    typescript = lang_config,
    javascript = lang_config,
  },
  on_attach = function(client, bufnr)
    local lsp_utils = require("lsp_utils")

    lsp_utils.on_attach(client, bufnr)

    local opts = function(desc)
      return { desc = desc, buffer = bufnr, silent = true, noremap = true }
    end

    map("n", "gD", function()
      -- Works without args
      ---@diagnostic disable-next-line: missing-parameter
      local params = vim.lsp.util.make_position_params()
      lsp_utils.execute_command({
        command = "typescript.goToSourceDefinition",
        arguments = { params.textDocument.uri, params.position },
        open = true,
      })
    end, opts("Goto Source Definition"))

    map("n", "gR", function()
      lsp_utils.execute_command({
        command = "typescript.findAllFileReferences",
        arguments = { vim.uri_from_bufnr(0) },
        open = true,
      })
    end, opts("File References"))

    map("n", "<leader>ci", lsp_utils.lsp_action["source.organizeImports"], opts("TS: Organize imports"))
    map("n", "<leader>cM", lsp_utils.lsp_action["source.addMissingImports.ts"], opts("TS: Add missing imports"))
    map("n", "<leader>cu", lsp_utils.lsp_action["source.removeUnused.ts"], opts("TS: Remove unused imports"))
    map("n", "<leader>cD", lsp_utils.lsp_action["source.fixAll.ts"], opts("TS: Fix all diagnostics"))
    map("n", "<leader>cV", function()
      lsp_utils.execute_command({ command = "typescript.selectTypeScriptVersion" })
    end, opts("TS: Select workspace version"))

    client.commands["_typescript.moveToFileRefactoring"] = function(command)
      ---@type string, string, lsp.Range
      local action, uri, range = unpack(command.arguments)

      local function move(newf)
        client:request("workspace/executeCommand", {
          command = command.command,
          arguments = { action, uri, range, newf },
        })
      end

      local fname = vim.uri_to_fname(uri)
      client:request("workspace/executeCommand", {
        command = "typescript.tsserverRequest",
        arguments = {
          "getMoveToRefactoringFileSuggestions",
          {
            file = fname,
            startLine = range.start.line + 1,
            startOffset = range.start.character + 1,
            endLine = range["end"].line + 1,
            endOffset = range["end"].character + 1,
          },
        },
      }, function(_, result)
        ---@type string[]
        local files = result.body.files
        table.insert(files, 1, "Enter new path...")
        vim.ui.select(files, {
          prompt = "Select move destination:",
          format_item = function(f)
            return vim.fn.fnamemodify(f, ":~:.")
          end,
        }, function(f)
          if f and f:find("^Enter new path") then
            vim.ui.input({
              prompt = "Enter move destination:",
              default = vim.fn.fnamemodify(fname, ":h") .. "/",
              completion = "file",
            }, function(newf)
              return newf and move(newf)
            end)
          elseif f then
            move(f)
          end
        end)
      end)
    end
  end,
}

return {
  "Bekaboo/dropbar.nvim",
  event = "LazyFile",
  opts = {
    icons = {
      ui = {
        bar = {
          separator = "  ",
          extends = "…",
        },
      },
    },
    -- Default function for displaying items in the bar
    -- bar = {
    --   sources = function(buf, _)
    --     local sources = require("dropbar.sources")
    --     local utils = require("dropbar.utils")
    --     if vim.bo[buf].ft == "markdown" then
    --       return {
    --         sources.path,
    --         sources.markdown,
    --       }
    --     end
    --     if vim.bo[buf].buftype == "terminal" then
    --       return {
    --         sources.terminal,
    --       }
    --     end
    --     return {
    --       sources.path,
    --       sources.lsp,
    --       utils.source.fallback({
    --         sources.lsp,
    --         sources.treesitter,
    --       }),
    --     }
    --   end,
    -- },
    sources = {
      path = {
        max_depth = 1,
      },
    },
  },
  keys = {
    {
      "<leader>;",
      function()
        require("dropbar.api").pick()
      end,
      desc = "Pick symbols in winbar",
    },
    {
      "[;",
      function()
        require("dropbar.api").goto_context_start()
      end,
      desc = "Go to start of current context",
    },
    {
      "];",
      function()
        require("dropbar.api").select_next_context()
      end,
      desc = "Select next context",
    },
  },
  init = function()
    require("which-key").add({
      { "<leader>;", group = "Dropbar", icon = { icon = "", color = "blue" } },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "fugitiveblame" },
      callback = function()
        vim.wo.winbar = " "
      end,
    })
  end,
}

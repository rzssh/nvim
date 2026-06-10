return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
      "xzbdmw/colorful-menu.nvim",
    },
    opts = {
      keymap = {
        preset = "none",
        ["<C-f>"] = { "accept", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      cmdline = {
        keymap = {
          preset = "none",
          ["<C-f>"] = { "accept", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        },
        completion = {
          menu = {
            auto_show = true,
          },
        },
      },
      completion = {
        -- Whether to show brackets in completion
        -- accept = { auto_brackets = { enabled = true } },
        trigger = {
          show_on_trigger_character = true,
        },
        documentation = {
          auto_show = true,
        },
        menu = {
          draw = {
            columns = { { "kind_icon", "label", "label_description", gap = 1 } },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,

                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              label_description = {
                width = { min = 20, max = 50 },

                highlight = function(ctx)
                  return ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel"
                end,
              },
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,

                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      signature = {
        enabled = true,
      },
    },
    -- init = function()
    --   -- Overriding vim.lsp.get_clients to filter out Augment Server for completion requests
    --   local original_get_clients = vim.lsp.get_clients
    --
    --   --- @diagnostic disable-next-line: duplicate-set-field
    --   vim.lsp.get_clients = function(opts)
    --     local clients = original_get_clients(opts)
    --
    --     if opts and opts.method == "textDocument/completion" then
    --       return vim.tbl_filter(function(client)
    --         return client.name ~= "Augment Server"
    --       end, clients)
    --     end
    --
    --     return clients
    --   end
    -- end,
  },
  {
    "saghen/blink.compat",
    version = "*",
    opts = {
      impersonate_nvim_cmp = true,
    },
  },
}

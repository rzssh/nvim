return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      "ravitemer/codecompanion-history.nvim",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionHistory",
      "CodeCompanionSummaries",
    },
    opts = {
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true, -- Show mcp tool results in chat
            make_vars = true, -- Convert resources to #variables
            make_slash_commands = true, -- Add prompts as /slash commands
          },
        },
        history = {
          enabled = true,
          opts = {
            keymap = "gh",
            save_chat_keymap = "sc",
            auto_save = true,
            expiration_days = 0,
            picker = "snacks",
            chat_filter = nil, -- function(chat_data) return boolean end
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
              duplicate = { n = "<C-y>", i = "<C-y>" },
            },
            auto_generate_title = true,
            title_generation_opts = {
              adapter = "openrouter_mimo",
              -- adapter = "copilot",
              -- model = "claude-sonnet-4.5",
              refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
              max_refreshes = 3,
              format_title = function(original_title)
                return original_title
              end,
            },
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            enable_logging = false,

            summary = {
              create_summary_keymap = "gcs",
              browse_summaries_keymap = "gbs",

              generation_opts = {
                adapter = nil, -- defaults to current chat adapter
                model = nil, -- defaults to current chat model
                context_size = 90000, -- max tokens that the model supports
                include_references = true, -- include slash command content
                include_tool_outputs = true, -- include tool execution results
                system_prompt = nil, -- custom system prompt (string or function)
                format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
              },
            },
            -- Memory system (requires VectorCode CLI)
            memory = {
              auto_create_memories_on_summary_generation = true,
              vectorcode_exe = "vectorcode",
              tool_opts = {
                default_num = 10,
              },
              notify = true,
              index_on_startup = false,
            },
          },
        },
      },
      adapters = {
        http = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = { model = { default = "claude-opus-4.5" } },
            })
          end,
          openrouter_grok = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://openrouter.ai/api",
                api_key = "OPENROUTER_API_KEY",
                chat_url = "/v1/chat/completions",
              },
              schema = { model = { default = "x-ai/grok-4.1-fast:free" } },
            })
          end,
          openrouter_mimo = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://openrouter.ai/api",
                api_key = "OPENROUTER_API_KEY",
                chat_url = "/v1/chat/completions",
              },
              schema = { model = { default = "xiaomi/mimo-v2-flash" } },
            })
          end,
        },
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_OAUTH_TOKEN",
              },
            })
          end,
          codex = function()
            return require("codecompanion.adapters").extend("codex", {
              defaults = {
                auth_method = "chatgpt",
              },
              env = {
                OPENAI_API_KEY = "OPENAI_API_KEY",
              },
            })
          end,
          -- opencode = function()
          --   return require("codecompanion.adapters").extend("opencode", {
          --     schema = {
          --       model = {
          --         default = "opencode/glm-4.7-free",
          --         choices = {
          --           ["opencode/glm-4.7-free"] = { opts = {} },
          --           ["opencode/minimax-m2.1-free"] = { opts = {} },
          --           ["opencode/grok-fast-code-1-free"] = { opts = {} },
          --           ["github-copilot/claude-sonnet-4.5"] = { opts = {} },
          --           ["github-copilot/claude-opus-4.5"] = { opts = {} },
          --           ["github-copilot/gpt-5.2"] = { opts = {} },
          --           ["github-copilot/gemini-3-pro-preview"] = { opts = {} },
          --         },
          --       },
          --     },
          --   })
          -- end,
        },
      },
      interactions = {
        chat = {
          slash_commands = {
            ["file"] = { opts = { provider = "snacks" } },
          },

          adapter = "claude_code",
        },
        inline = {
          adapter = "openrouter_mimo",
        },
      },
      display = {
        -- chat = {
        --   show_settings = true,
        -- },

        action_palette = {
          provider = "default",
        },

        diff = {
          provider = "mini_diff",
        },
      },
    },
    -- stylua: ignore start
    keys = {
      {
        "<leader>ai",
        require("utils").create_input_cmd_visual_callback("CodeCompanion"),
        desc = "Codecompanion: Inline assistant",
        mode = { "n", "v" },
      },
      { "<leader>aa", ":CodeCompanionChat adapter=auggie<CR>", desc = "Codecompanion: Auggie" },
      { "<leader>ac", ":CodeCompanionChat adapter=claude_code<CR>", desc = "Codecompanion: Claude Code" },
      { "<leader>aO", ":CodeCompanionChat adapter=codex<CR>", desc = "Codecompanion: Codex" },
      { "<leader>aC", ":CodeCompanionChat adapter=copilot<CR>", desc = "Codecompanion: Copilot (Claude)" },
      { "<leader>ao", ":CodeCompanionChat adapter=opencode<CR>", desc = "Codecompanion: OpenCode" },
      { "<leader>ag", ":CodeCompanionChat adapter=openrouter_grok<CR>", desc = "Codecompanion: Grok 4.1 Fast" },
      { "<leader>at", ":CodeCompanionChat Toggle<CR>", desc = "Codecompanion: toggle" },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "MCPHub",
    build = "bundled_build.lua",
    opts = {
      use_bundled_binary = true,

      port = 37373,
      config = vim.fn.expand("~/.config/mcpservers.json"),

      auto_approve = false,
      auto_toggle_mcp_servers = false,

      log = {
        level = vim.log.levels.WARN,
        to_file = false,
        file_path = nil,
        prefix = "MCPHub",
      },
    },
    keys = {
      { "<leader>ah", ":MCPHub<CR>", desc = "Open MCP Hub" },
    },
    init = function()
      require("which-key").add({
        { "<leader>a", group = "AI (Codecompanion)", icon = { icon = "", color = "orange" } },
      })

      local root_dir = require("utils").workspace_root()
      if root_dir ~= nil then
        -- Set the environment variable before loading the config
        -- Used by MCP servers that require project's root path as an argument
        vim.fn.setenv("MCP_PROJECT_ROOT_PATH", root_dir)
      end
    end,
  },
}

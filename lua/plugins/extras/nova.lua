return {
  dir = "~/projects/nova.nvim",
  enabled = false,
  event = "InsertEnter",
  cmd = { "NovaEnable", "NovaDisable", "NovaToggle", "NovaClearCache", "NovaStats" },
  opts = {
    provider = "cerebras_gpt", -- available by default: llamacpp, openrouter (uses qwen-2.5-coder-32b)

    providers = {
      cerebras_llama = {
        adapter = "openai_chat",
        endpoint = "https://api.cerebras.ai/v1/chat/completions",
        api_key_env = "CEREBRAS_API_KEY",
        model = "llama-3.3-70b",
        debounce = 150,
        speculative_prefetch = false,
        max_tokens = 128,
      },

      cerebras_gpt = {
        adapter = "openai_chat",
        endpoint = "https://api.cerebras.ai/v1/chat/completions",
        api_key_env = "CEREBRAS_API_KEY",
        model = "gpt-oss-120b",
        max_tokens = 256,
        extra_body = { reasoning_effort = "low" },
        debounce = 300,
        speculative_prefetch = false,
      },

      deepseek_fim = {
        adapter = "openai_fim",
        endpoint = "https://api.deepseek.com/beta/completions",
        api_key_env = "DEEPSEEK_API_KEY",
        model = "deepseek-chat",
        debounce = 300,
        suffix_param = true,
        speculative_prefetch = false,
        max_tokens = 96,
        max_prefix_chars = 4000,
        max_suffix_chars = 1000,
      },
    },

    ring = {
      enabled = true,
      max_chunks = 8,
      chunk_size = 32,
    },

    ignore_filetypes = { "oil", "qf", "help" },
  },
  init = function()
    vim.g.nova_debug = false
  end,
}

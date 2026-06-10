return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = {
    "copilotlsp-nvim/copilot-lsp",
    init = function()
      vim.g.copilot_nes_debounce = 500
    end,
  },
  opts = {
    nes = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept_and_goto = "<M-l>",
        accept = false,
        dismiss = false,
      },
    },
    panel = {
      enabled = true,
      auto_refresh = true,
      keymap = {
        jump_prev = "[s",
        jump_next = "]s",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-h>",
      },
      layout = {
        position = "bottom", -- | top | left | right | bottom |
        ratio = 0.4,
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      debounce = 75,
      trigger_on_accept = true,
      keymap = {
        -- remapped in init
        accept = false,
        accept_word = "<C-w>",
        accept_line = "<C-l>",
        next = "]]",
        prev = "[[",
        dismiss = false,
      },
    },
  },
  keys = {
    { "<leader>ap", "<cmd>Copilot panel<cr>", desc = "Copilot Panel", mode = "n" },
  },
  config = function(_, opts)
    opts = vim.tbl_deep_extend("force", opts, {
      suggestion = {
        enabled = vim.g.copilot_enabled,
      },
    })

    local copilot_suggestion = require("copilot.suggestion")
    local copilot_nes = require("copilot-lsp.nes")

    vim.keymap.set("n", "<Tab>", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local state = vim.b[bufnr].nes_state

      if state then
        -- Try to jump to the start of the suggestion edit.
        -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
        local _ = copilot_nes.walk_cursor_start_edit()
          or (copilot_nes.apply_pending_nes() and copilot_nes.walk_cursor_end_edit())
        return nil
      end

      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    end, { desc = "Accept Copilot NES suggestion", expr = true })

    vim.keymap.set("n", "<Esc>", function()
      if copilot_suggestion.is_visible() then
        copilot_suggestion.dismiss()
        return
      end

      local bufnr = vim.api.nvim_get_current_buf()
      local state = vim.b[bufnr].nes_state

      if state then
        copilot_nes.clear()
        return
      end

      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end, { desc = "Accept Copilot NES suggestion", expr = true })

    if vim.g.copilot_enabled then
      vim.keymap.set("i", "<Tab>", function()
        if copilot_suggestion.is_visible() then
          copilot_suggestion.accept()
          return
        end

        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
          "n",
          false
        )
      end, { silent = true })
    end

    require("copilot").setup(opts)
  end,
}

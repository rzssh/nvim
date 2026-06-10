return {
  {
    "gruvw/strudel.nvim",
    -- Doesn't override filetypes if not loaded beforehand
    -- ft = { "str", "std" },
    event = "VeryLazy",
    build = "npm ci",
    opts = {
      ui = {
        -- Maximise the menu panel
        maximise_menu_panel = true,
        -- Hide the Strudel menu panel (and handle)
        hide_menu_panel = false,
        -- Hide the default Strudel top bar (controls)
        hide_top_bar = false,
        -- Hide the Strudel code editor
        hide_code_editor = false,
        -- Hide the Strudel eval error display under the editor
        hide_error_display = false,
      },
      -- Automatically start playback when launching Strudel
      start_on_launch = true,
      -- Set to `true` to automatically trigger the code evaluation after saving the buffer content
      update_on_save = false,
      -- Enable two-way cursor position sync between Neovim and Strudel editor
      sync_cursor = true,
      -- Report evaluation errors from Strudel as Neovim notifications
      report_eval_errors = true,
      custom_css_file = nil,
      -- Headless mode: set to `true` to run the browser without launching a window
      headless = false,
      -- Path to a (chromium-based) browser executable of choice
      -- browser_exec_path = "/path/to/browser/executable",
    },
  -- stylua: ignore start
  keys = {
    { "<leader>Ml", vim.cmd.StrudelLaunch, desc = "Launch" },
    { "<leader>Mq", vim.cmd.StrudelQuit, desc = "Quit" },
    { "<leader>Mt", vim.cmd.StrudelToggle, desc = "Toggle" },
    { "<leader>Mu", vim.cmd.StrudelUpdate, desc = "Update" },
    { "<leader>Ms", vim.cmd.StrudelStop, desc = "Stop" },
    { "<leader>Mx", vim.cmd.StrudelExecute, desc = "Execute" },
    { "<leader>Mb", vim.cmd.StrudelSetBuffer, desc = "Set buffer" },
  },
    -- stylua: ignore end
    init = function()
      require("which-key").add({
        { "<leader>M", group = "Strudel", icon = { icon = "", color = "purple" } },
      })

      local no_lsp_extensions = { "str", "std" }
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufname = vim.api.nvim_buf_get_name(args.buf)
          local ext = bufname:match("%.(%w+)$")
          if ext and vim.tbl_contains(no_lsp_extensions, ext) then
            vim.schedule(function()
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client then
                vim.lsp.buf_detach_client(args.buf, client.id)
              end
            end)
          end
        end,
      })
    end,
  },
  {
    "thgrund/tidal.nvim",
    pin = true, -- has local marker.lua fix
    ft = { "tidal" },
    opts = {
      --- Configure TidalLaunch command
      boot = {
        tidal = {
          --- Command to launch ghci with tidal installation
          cmd = "ghci",
          args = { "-v0" },
          --- Custom boot file with editor target for event highlighting (tidal 1.9.5 compatible)
          file = vim.fn.expand("~/.config/tidal/BootTidal.hs"),
          enabled = true,
          highlight = {
            autostart = false,
            styles = {
              osc = {
                ip = "127.0.0.1",
                port = 3335,
              },
              -- [Tidal ID] -> hl style
              custom = {
                ["drums"] = { bg = "#e7b9ed", foreground = "#000000" },
                ["2"] = { bg = "#b9edc7", foreground = "#000000" },
              },
              global = {
                baseName = "CodeHighlight",
                style = { bg = "#7eaefc", foreground = "#000000" },
              },
            },
            events = {
              osc = {
                ip = "127.0.0.1",
                port = 6013,
              },
            },
            fps = 30,
          },
        },
        sclang = {
          --- Command to launch SuperCollider
          cmd = "sclang",
          args = {},
          --- SuperCollider boot file
          file = vim.api.nvim_get_runtime_file("bootfiles/BootSuperDirt.scd", false)[1],
          enabled = true,
        },
        split = "v",
      },
      --- Default keymaps
      --- Set to false to disable all default mappings
      --- @type table | nil
      mappings = {
        send_line = { mode = { "i", "n" }, key = "<leader>Te" },
        send_visual = { mode = { "x" }, key = "<leader>Te" },
        send_block = { mode = { "i", "n", "x" }, key = "<leader>Tb" },
        send_node = { mode = "n", key = "<leader>Tn" },
        send_silence = { mode = "n", key = "<leader>Td" },
        send_hush = { mode = "n", key = "<leader>TH" },
      },
      ---- Configure highlight applied to selections sent to tidal interpreter
      selection_highlight = {
        --- Highlight definition table
        --- see ':h nvim_set_hl' for details
        --- @type vim.api.keyset.highlight
        highlight = { link = "IncSearch" },
        --- Duration to apply the highlight for
        timeout = 150,
      },
    },
    keys = {
      { "<leader>Tl", "<cmd>TidalLaunch<cr>", desc = "Launch" },
      { "<leader>Tq", "<cmd>TidalQuit<cr>", desc = "Quit" },
      { "<leader>Th", "<cmd>TidalStartEventHighlighting<cr>", desc = "Start event highlighting" },
      { "<leader>Tk", "<cmd>TidalStopEventHighlighting<cr>", desc = "Stop event highlighting" },
      { "<leader>To", "<cmd>TidalNotification<cr>", desc = "Tidal output" },
      { "<leader>Ts", "<cmd>SuperColliderNotification<cr>", desc = "SuperCollider output" },
    },
    init = function()
      require("which-key").add({
        { "<leader>T", group = "Tidal", icon = { icon = "♫", color = "purple" } },
      })
    end,
  },
}

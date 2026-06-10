-- Pre-requisites:
-- 1. `sshfs` installation
-- 2. macOS requires macFUSE: https://macfuse.github.io/
--   - https://github.com/macfuse/macfuse/wiki/File-Systems-%E2%80%90-SSHFS

-- Run :checkhealth sshfs to verify installation
return {
  "uhs-robert/sshfs.nvim",
  event = "VeryLazy",
  opts = {
    ui = {
      -- "auto"
      -- "snacks"
      -- "fzf-lua"
      -- "mini"
      -- "telescope"
      -- "oil"
      -- "neo-tree"
      -- "nvim-tree"
      -- "yazi"
      -- "lf"
      -- "nnn"
      -- "ranger"
      -- "netrw"
      local_picker = {
        preferred_picker = "auto",
      },
      remote_picker = {
        preferred_picker = "snacks",
      },
    },
    lead_prefix = "<leader>S",
  },
}

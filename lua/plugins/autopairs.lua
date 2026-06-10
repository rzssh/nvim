return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  opts = {
    map_cr = true,
    check_ts = true,
    ts_config = {
      lua = { "string" }, -- avoid pairs in lua strings
      javascript = { "template_string" }, -- don't add pairs in js template_strings
    },
  },
  config = function(_, opts)
    local Rule = require("nvim-autopairs.rule")
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)

    npairs.add_rule(Rule("|", "|", { "zig", "rust" }))
  end,
}

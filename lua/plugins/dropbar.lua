return {
  "Bekaboo/dropbar.nvim",
  event = "LazyFile",
  keys = {
    {
      "<leader>;",
      function()
        require("dropbar.api").pick()
      end,
      desc = "Pick breadcrumb",
    },
  },
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    notifier = { enabled = true },
    picker = { enabled = true },
  },
  keys = {
    {
      "<leader>gf",
      function()
        Snacks.picker.git_files()
      end,
      mode = "n",
      desc = "[G]it [F]iles",
    },
  },
}

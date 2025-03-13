return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      current_line_blame = true,
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
    key = {
      {
        "<leader>ga",
        "<Cmd>Gitsigns blame",
        mode = { "n", "v" },
        desc = "[G]it Bl[a]me",
      },
    },
  },
}

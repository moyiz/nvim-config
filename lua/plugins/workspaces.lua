return {
  "natecraddock/workspaces.nvim",
  opts = {
    cd_type = "tab",
    hooks = {
      open = {
        function(_, path)
          require("oil").open(path)
        end,
      },
    },
  },
  keys = {
    {
      "<leader>w",
      "<cmd>WorkspacesOpen<cr>",
      mode = "n",
      desc = "Open [W]orkspace",
    },
  },
}

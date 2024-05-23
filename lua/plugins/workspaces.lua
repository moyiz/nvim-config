return {
  "natecraddock/workspaces.nvim",
  opts = {
    cd_type = "global",
    hooks = {
      open = { "Telescope find_files" },
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

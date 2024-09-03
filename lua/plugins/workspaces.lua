return {
  "natecraddock/workspaces.nvim",
  event = "VeryLazy",
  opts = {
    cd_type = "tab",
    hooks = {
      open = {
        function(_, path)
          vim.cmd("edit " .. path)
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

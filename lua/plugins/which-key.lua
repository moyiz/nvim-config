return {
  {
    "folke/which-key.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      -- vim.o.timeout = true
      -- vim.o.timeoutlen = 30
      require("which-key").setup {
        delay = 30,
      }

      -- Document existing key chains
      require("which-key").add {
        { "<leader>c", desc = "[C]ode" },
        { "<leader>cs", desc = "[S]ymbols" },
        { "<leader>s", desc = "[S]earch" },
        { "<leader>d", desc = "[D]ebug" },
        { "<leader>m", desc = "[M]ap" },
        { "<leader>t", desc = "[T]elescope" },
        { "<leader>g", desc = "[G]it" },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

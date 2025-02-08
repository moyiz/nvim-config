return {
  {
    -- dir = "~/workspace/neovim/perception.nvim",
    "moyiz/perception.nvim",
    lazy = true,
    cmd = { "PerceptionUI" },
    ---@type perception.Config
    opts = {
      base = {
        ignore_hl = { "Demo" },
      },
    },
  },
}

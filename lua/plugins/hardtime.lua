return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    max_count = 5,
    disable_mouse = false,
    disabled_keys = {
      ["<Left>"] = false,
      ["<Down>"] = false,
      ["<Up>"] = false,
      ["<Right>"] = false,
    },
    restricted_keys = {
      ["<Left>"] = { "n", "x" },
      ["<Down>"] = { "n", "x" },
      ["<Up>"] = { "n", "x" },
      ["<Right>"] = { "n", "x" },
    },
  },
}

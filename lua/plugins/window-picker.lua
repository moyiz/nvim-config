return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  event = "VeryLazy",
  version = "2.*",
  keys = {
    {
      "<leader>,",
      function()
        local win_id = require("window-picker").pick_window()
        if win_id ~= nil then
          vim.fn.win_gotoid(win_id)
        end
      end,
      mode = "n",
      desc = "Window picker",
    },
  },
  opts = {
    hint = "floating-big-letter",
    selection_chars = "tnresaluc,io",
    filter_rules = {
      include_current_win = true,
      bo = {
        filetype = {
          "NvimTree",
          "neo-tree",
          "neo-tree-popup",
          "notify",
          "minifiles",
          "minipick",
          "incline",
        },
        buftype = { "quickfix", "ministarter" },
        -- buftype = { "terminal", "quickfix", "ministarter" },
      },
    },
  },
}

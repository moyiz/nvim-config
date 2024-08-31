return {
  "dasupradyumna/midnight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local colors = require "midnight.colors"
    -- colors.palette.black = "#000000"
    colors.components.bg = "#000000"
    require("midnight").setup()
    vim.cmd.colorscheme "midnight"
  end,
}

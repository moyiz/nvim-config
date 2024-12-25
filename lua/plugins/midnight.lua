return {
  "dasupradyumna/midnight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local colors = require "midnight.colors"
    local p = colors.palette
    local c = colors.components

    c.bg = "#000000"

    require("midnight").setup {
      MiniStarterSection = {
        link = "Keyword",
      },
      MiniStarterFooter = {
        link = "Include",
      },
      MiniStarterItemPrefix = {
        link = "Parameter",
      },
      -- MiniStarterItem = {
      --   link = "Function",
      -- },
      MiniStatuslineModeCommand = {
        fg = p.black,
        bg = p.yellow[1],
        bold = true,
      },
      -- MiniStatuslineDevinfo = { fg = c.fg, bg = c.fg },
      -- MiniStatuslineFileinfo = { fg = c.fg, bg = c.fg },
      -- MiniStatuslineFilename = { fg = c.fg, bg = p.bg },
      -- MiniStatuslineInactive = { fg = p.blue[1], bg = p.bg_statusline },
      MiniStatuslineModeInsert = { fg = p.black, bg = p.green[3], bold = true },
      MiniStatuslineModeNormal = { fg = p.black, bg = p.blue[4], bold = true },
      MiniStatuslineModeOther = { fg = p.black, bg = p.teal[1], bold = true },
      MiniStatuslineModeReplace = { fg = p.black, bg = p.red[3], bold = true },
      MiniStatuslineModeVisual = {
        fg = p.black,
        bg = p.magenta[2],
        bold = true,
      },
      NonText = {
        link = "DiffviewNonText",
      },
    }
    vim.cmd.colorscheme "midnight"
  end,
}

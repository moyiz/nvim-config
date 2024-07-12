return {
  {
    "folke/tokyonight.nvim",
    -- enabled = false,
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("tokyonight").setup {
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        on_highlights = function(hl, c)
          hl.Comment = {
            italic = true,
            fg = "#207ffc",
          }
          hl.DiagnosticUnnecessary = {
            underline = true,
            fg = "#207ffc",
          }
        end,
      }
      vim.cmd.colorscheme "tokyonight-storm"
    end,
  },
}

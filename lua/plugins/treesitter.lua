return {
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    -- lazy = true,
    event = "VeryLazy",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "bash",
          "c",
          "go",
          "html",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "vim",
          "vimdoc",
          "yaml",
        },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      }

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see :help nvim-treesitter-incremental-selection-mod
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

      require("treesitter-context").setup {
        multiline_threshold = 3,
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

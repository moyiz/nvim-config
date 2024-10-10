return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- lazy = true,
    event = "VeryLazy",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "bash",
          "c",
          "go",
          "html",
          "java",
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
        textobjects = {
          lsp_interop = {
            enable = true,
            border = "single",
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>k"] = "@function.outer",
              ["<leader>K"] = "@class.outer",
            },
          },
        },
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

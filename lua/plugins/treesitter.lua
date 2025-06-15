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
        modules = {},
        ensure_installed = {
          "bash",
          "c",
          "go",
          "html",
          "java",
          "json",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "vim",
          "vimdoc",
          "yaml",
        },
        sync_install = false,
        ignore_install = {},
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        indent = {
          enable = true,
          disable = { "markdown" }, -- To prevent bad indentation in lists.
        },
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
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]s"] = {
                query = "@local.scope",
                query_group = "locals",
                desc = "Next scope",
              },
            },
            goto_previous_start = {
              ["[s"] = {
                query = "@local.scope",
                query_group = "locals",
                desc = "Previous scope",
              },
            },
          },
        },
      }

      require("treesitter-context").setup {
        multiline_threshold = 3,
        separator = "—",
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require "nvim-treesitter"
      ts.setup {}
      local ensure_installed = {
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
      }
      ts.install(ensure_installed)
      -- local already_installed = ts.get_installed "parsers"
      -- local parsers_to_install = vim
      --   .iter(ensure_installed)
      --   :filter(function(parser)
      --     return not vim.tbl_contains(already_installed, parser)
      --   end)
      --   :totable()
      -- if #parsers_to_install > 0 then
      --   ts.install(parsers_to_install)
      -- end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          pcall(function()
            vim.treesitter.start()
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end)
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup {
        move = {
          enable = true,
          set_jumps = true,
        },
      }

      local move = require "nvim-treesitter-textobjects.move"
      local select = require "nvim-treesitter-textobjects.select"

      vim.keymap.set({ "n", "x", "o" }, "[a", function()
        move.goto_previous_start("@parameter.inner", "textobjects")
      end, { desc = "Previous argument" })

      vim.keymap.set({ "n", "x", "o" }, "]a", function()
        move.goto_next_start("@parameter.inner", "textobjects")
      end, { desc = "Next argument" })

      vim.keymap.set({ "n", "x", "o" }, "[A", function()
        move.goto_previous_end("@parameter.outer", "textobjects")
      end, { desc = "Previous argument end" })

      vim.keymap.set({ "n", "x", "o" }, "]A", function()
        move.goto_next_end("@parameter.outer", "textobjects")
      end, { desc = "Next argument end" })

      vim.keymap.set({ "n", "x", "o" }, "[s", function()
        move.goto_previous_start("@local.scope", "locals")
      end, { desc = "Previous scope" })

      vim.keymap.set({ "n", "x", "o" }, "]s", function()
        move.goto_next_start("@local.scope", "locals")
      end, { desc = "Next scope" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      multiline_threshold = 3,
      separator = "—",
    },
  },
}

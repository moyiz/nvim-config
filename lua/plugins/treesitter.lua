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

      local group = vim.api.nvim_create_augroup("user-treesitter", {
        clear = true,
      })
      local max_filesize = 1024 * 1024
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        desc = "Start treesitter highlighting; use its indent only as a fallback",
        callback = function(args)
          local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
          if stat and stat.size > max_filesize then
            -- The runtime ftplugins for lua, markdown, help and query start
            -- treesitter before this runs, so stop rather than just skip.
            pcall(vim.treesitter.stop, args.buf)
            return
          end

          if not pcall(vim.treesitter.start) then
            return
          end

          -- Prefer the runtime indent wherever one exists.
          -- Fallback to treesitter instead of plain autoindent.
          if vim.bo.indentexpr ~= "" or vim.bo.cindent or vim.bo.lisp then
            return
          end
          local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
          if lang and vim.treesitter.query.get(lang, "indents") then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
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

      -- Capitalised so `[s` / `]s` stay with spell checking, which is on
      -- globally via `vim.opt.spell`.
      vim.keymap.set({ "n", "x", "o" }, "[S", function()
        move.goto_previous_start("@local.scope", "locals")
      end, { desc = "Previous scope" })

      vim.keymap.set({ "n", "x", "o" }, "]S", function()
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

return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "mikavilpas/blink-ripgrep.nvim",
      "moyiz/blink-emoji.nvim",
    },
    version = "*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      -- https://cmp.saghen.dev/configuration/keymap.html
      keymap = {
        preset = "default",
        ["<C-e>"] = {},
        ["<C-q>"] = { "hide" },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
      },
      cmdline = {
        keymap = {
          preset = "default",
        },
        completion = {
          menu = {
            auto_show = true,
          },
        },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        ghost_text = { enabled = true },
        menu = {
          auto_show = true,
          border = "single",
          max_height = 25,
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
            components = {
              source_name = {
                highlight = "Keyword",
              },
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ =
                    require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                -- Optionally, you may also use the highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          -- To improve performance
          -- treesitter_highlighting = false,
          window = { border = "single" },
        },
      },
      fuzzy = {
        sorts = {
          "exact",
          "score",
          "sort_text",
        },
      },
      signature = {
        enabled = true,
        window = { border = "single" },
      },
      sources = {
        default = {
          "lazydev",
          "lsp",
          "path",
          "snippets",
          "buffer",
          "ripgrep",
          "emoji",
          "cwdpath",
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          cwdpath = {
            module = "blink.cmp.sources.path",
            score_offset = 5,
            fallbacks = { "buffer" },
            opts = {
              trailing_slash = true,
              label_trailing_slash = true,
              -- path completions to be relative to cwd (instead of buffer)
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
              show_hidden_files_by_default = true,
              -- Treat `/path` as starting from the current working directory (cwd) instead of the root of your filesystem
              ignore_root_slash = false,
            },
          },
          path = {
            score_offset = 3,
            opts = {
              show_hidden_files_by_default = true,
            },
          },
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            -- the options below are optional, some default values are shown
            ---@module "blink-ripgrep"
            ---@type blink-ripgrep.Options
            opts = {},
          },
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            -- score_offset = 15,
          },
          lsp = {
            score_offset = 500,
          },
          snippets = {
            should_show_items = function(ctx)
              return ctx.trigger.initial_kind ~= "trigger_character"
            end,
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}

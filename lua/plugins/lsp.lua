return {
  {
    "neovim/nvim-lspconfig",
    -- lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        lazy = true,
        cmd = {
          "Mason",
          "MasonInstall",
          "MasonInstallAll",
          "MasonUninstall",
          "MasonUninstallAll",
          "MasonLog",
        },
        opts = {},
      },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- UI for notifications and LSP progress messages
      { "j-hui/fidget.nvim", opts = {} },

      { "tridactyl/vim-tridactyl", ft = "tridactyl" },
      { "towolf/vim-helm", ft = "helm" },
      -- {
      --   "nvim-java/nvim-java",
      --   ft = "java",
      --   opts = {
      --     notifications = {
      --       dap = false,
      --     },
      --   },
      -- },

      {
        "rachartier/tiny-code-action.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "LspAttach",
        opts = {
          -- Use 'buffer' for previews
          picker = {
            "buffer",
            opts = {
              auto_preview = true,
              hotkeys = true,
            },
          },
        },
      },

      {
        "folke/lazydev.nvim",
        ft = "lua",
        dependencies = {
          { "Bilal2453/luvit-meta", lazy = true },
        },
        opts = {
          library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
          },
        },
      },

      {
        "stevearc/aerial.nvim",
        keys = {
          {
            "<leader>co",
            "<cmd>AerialToggle!<cr>",
            desc = "[C]ode [O]utline",
          },
        },
        opts = {
          layout = {
            default_direction = "prefer_left",
          },
          highlight_on_hover = true,
          manage_folds = true,
          link_folds_to_tree = true,
          show_guides = true,
        },
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set(
              "n",
              keys,
              func,
              { buffer = event.buf, desc = "LSP: " .. desc }
            )
          end

          map(
            "gd",
            -- require("telescope.builtin").lsp_definitions,
            function()
              require("mini.extra").pickers.lsp { scope = "definition" }
            end,
            "[G]oto [D]efinition"
          )
          map(
            "gD",
            -- vim.lsp.buf.declaration,
            function()
              require("mini.extra").pickers.lsp { scope = "declaration" }
            end,
            "[G]oto [D]eclaration"
          )
          map(
            "gr",
            -- require("telescope.builtin").lsp_references,
            function()
              require("mini.extra").pickers.lsp { scope = "references" }
            end,
            "[G]oto [R]eferences"
          )

          map(
            "gI",
            -- require("telescope.builtin").lsp_implementations,
            function()
              require("mini.extra").pickers.lsp { scope = "implementation" }
            end,
            "[G]oto [I]mplementation"
          )

          map(
            "gy",
            -- require("telescope.builtin").lsp_type_definitions,
            function()
              require("mini.extra").pickers.lsp { scope = "type_definition" }
            end,
            "{G]oto T[y]pe def"
          )

          map("<leader>cr", vim.lsp.buf.rename, "[R]ename")

          -- map("<leader>ca", vim.lsp.buf.code_action, "[A]ction")
          map("<leader>ca", function()
            require("tiny-code-action").code_action {}
          end, "[A]ction")

          -- Format buffer
          vim.keymap.set(
            { "n", "v" },
            "<leader>cf",
            vim.lsp.buf.format,
            { buffer = event.buf, desc = "LSP: [F]ormat" }
          )

          map(
            "<leader>csd",
            -- require("telescope.builtin").lsp_document_symbols,
            function()
              require("mini.extra").pickers.lsp { scope = "document_symbol" }
            end,
            "[D]ocument"
          )

          map(
            "<leader>csw",
            -- require("telescope.builtin").lsp_dynamic_workspace_symbols,
            function()
              require("mini.extra").pickers.lsp { scope = "workspace_symbol" }
            end,
            "[W]orkspace"
          )

          vim.diagnostic.config { virtual_text = true, virtual_lines = false }
          -- Toggle diagnostics
          map("<leader>cc", function()
            local state = not vim.diagnostic.is_enabled()
            vim.diagnostic.enable(state)
            -- vim.diagnostic.config { virtual_lines = state }
          end, "Toggle diagnostics")

          -- Diagnostic keymaps
          vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump { count = -1, float = true }
          end, { desc = "Go to previous [D]iagnostic message" })
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump { count = 1, float = true }
          end, { desc = "Go to next [D]iagnostic message" })
          vim.keymap.set(
            "n",
            "<leader>ce",
            vim.diagnostic.open_float,
            { desc = "Show diagnostic [E]rror messages" }
          )
          vim.keymap.set(
            "n",
            "<leader>cq",
            vim.diagnostic.setloclist,
            { desc = "Open diagnostic [Q]uickfix list" }
          )

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map("K", vim.lsp.buf.hover, "Hover Documentation")

          -- Show errors and warnings in a floating window
          -- vim.api.nvim_create_autocmd("CursorHold", {
          --   callback = function()
          --     vim.diagnostic.open_float(nil, {
          --       focusable = false,
          --       source = "if_many",
          --       severity_sort = true,
          --     })
          --   end,
          -- })

          -- Highlight references of current word
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client and client.server_capabilities.documentHighlightProvider
          then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- Per-server overrides live in `lsp/<name>.lua`
      require("mason-tool-installer").setup {
        ensure_installed = {
          "actionlint",
          "asm_lsp",
          "asmfmt",
          "basedpyright",
          "bashls",
          "checkmake",
          "clangd",
          "golangci-lint",
          "golangci-lint-langserver",
          "gopls",
          "hclfmt",
          "helm_ls",
          "jdtls",
          "jsonls",
          "lua_ls",
          "nim_langserver",
          "prettier",
          "ruff",
          "rust_analyzer",
          "shellcheck",
          "stylua",
          "terraformls",
          "tflint",
          "ty",
          "yamlls",
          "zls",
        },
      }

      require("mason-lspconfig").setup {
        ensure_installed = {},
        automatic_enable = true,
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

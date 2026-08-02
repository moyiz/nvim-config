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
    },
    config = function()
      vim.diagnostic.config { virtual_text = true, virtual_lines = false }
      -- Toggle diagnostics
      vim.keymap.set("n", "<leader>cc", function()
        local state = not vim.diagnostic.is_enabled()
        vim.diagnostic.enable(state)
        -- vim.diagnostic.config { virtual_lines = state }
      end, { desc = "Toggle diagnostics" })

      -- Diagnostic keymaps
      vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump { count = -1, float = true }
      end, { desc = "Previous [D]iagnostic" })
      vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump { count = 1, float = true }
      end, { desc = "Next [D]iagnostic" })
      vim.keymap.set(
        "n",
        "<leader>ce",
        vim.diagnostic.open_float,
        { desc = "Diagnostic [E]rror messages" }
      )
      vim.keymap.set(
        "n",
        "<leader>cq",
        vim.diagnostic.setloclist,
        { desc = "Diagnostic [Q]uickfix list" }
      )

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(
              mode or "n",
              keys,
              func,
              { buffer = event.buf, desc = "LSP: " .. desc }
            )
          end

          map("grd", function()
            require("mini.extra").pickers.lsp { scope = "definition" }
          end, "[D]efinition")

          map("grD", function()
            require("mini.extra").pickers.lsp { scope = "declaration" }
          end, "[D]eclaration")

          map("grr", function()
            require("mini.extra").pickers.lsp { scope = "references" }
          end, "[R]eferences")

          map("gri", function()
            require("mini.extra").pickers.lsp { scope = "implementation" }
          end, "[I]mplementation")

          map("grt", function()
            require("mini.extra").pickers.lsp { scope = "type_definition" }
          end, "[T]ype definition")

          map("grn", vim.lsp.buf.rename, "Re[n]ame")

          map("gra", function()
            require("tiny-code-action").code_action {}
          end, "Code [A]ction", { "n", "x" })

          -- Format buffer
          vim.keymap.set(
            { "n", "v" },
            "<leader>cf",
            vim.lsp.buf.format,
            { buffer = event.buf, desc = "LSP: [F]ormat" }
          )

          map("<leader>csd", function()
            require("mini.extra").pickers.lsp { scope = "document_symbol" }
          end, "[D]ocument")

          map("<leader>csw", function()
            require("mini.extra").pickers.lsp { scope = "workspace_symbol" }
          end, "[W]orkspace")

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

          -- Highlight references of current word.
          -- The group is per-buffer and cleared on creation, so a second client
          -- attaching (or a server restart) replaces these rather than stacking
          -- another copy onto a CursorHold hot path.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client and client:supports_method "textDocument/documentHighlight"
          then
            local hl_group = vim.api.nvim_create_augroup(
              "user-lsp-highlight-" .. event.buf,
              { clear = true }
            )

            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = hl_group,
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              group = hl_group,
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = hl_group,
              buffer = event.buf,
              callback = function(detach)
                -- Only tear down once no highlight-capable client is left.
                for _, c in ipairs(vim.lsp.get_clients { bufnr = detach.buf }) do
                  if
                    c.id ~= detach.data.client_id
                    and c:supports_method "textDocument/documentHighlight"
                  then
                    return
                  end
                end
                vim.lsp.buf.clear_references()
                pcall(vim.api.nvim_del_augroup_by_id, hl_group)
              end,
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
          "pyrefly",
          "ruff",
          "rust_analyzer",
          "shellcheck",
          "stylua",
          "terraformls",
          "tflint",
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

  {
    "tridactyl/vim-tridactyl",
    ft = "tridactyl",
    init = function()
      vim.filetype.add {
        pattern = { [".*tridactylrc"] = "tridactyl" },
      }
    end,
  },

  {
    "towolf/vim-helm",
    ft = "helm",
    init = function()
      -- A chart file is one under `templates/` whose chart root has a
      -- `Chart.yaml`, which is why this cannot be a plain pattern.
      local chart_template = function(path)
        local root = path:match "^(.*)/templates/"
        if root ~= nil and vim.uv.fs_stat(root .. "/Chart.yaml") ~= nil then
          return "helm"
        end
      end
      vim.filetype.add {
        pattern = {
          [".*/templates/.*%.ya?ml"] = chart_template,
          [".*/templates/.*%.tpl"] = chart_template,
          [".*/templates/.*%.txt"] = chart_template,
          [".*/[^/]*helmfile[^/]*%.ya?ml"] = "helm",
          -- Beats the `templates/` rules above, as in the plugin's ftdetect.
          [".*/values[^/]*%.yaml"] = { "yaml.helm-values", { priority = 1 } },
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

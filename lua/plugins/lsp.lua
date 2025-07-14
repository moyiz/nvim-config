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
        dependencies = {
          { "nvim-lua/plenary.nvim" },
          { "nvim-telescope/telescope.nvim" },
        },
        event = "LspAttach",
        opts = {
          telescope_opts = {
            layout_strategy = "vertical",
            layout_config = {
              width = 0.6,
              height = 0.8,
              preview_cutoff = 1,
              preview_height = function(_, _, max_lines)
                local h = math.floor(max_lines * 0.7)
                return math.max(h, 10)
              end,
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
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set(
              "n",
              keys,
              func,
              { buffer = event.buf, desc = "LSP: " .. desc }
            )
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-T>.
          map(
            "gd",
            require("telescope.builtin").lsp_definitions,
            "[G]oto [D]efinition"
          )
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- Find references for the word under your cursor.
          map(
            "gr",
            require("telescope.builtin").lsp_references,
            "[G]oto [R]eferences"
          )

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map(
            "gI",
            require("telescope.builtin").lsp_implementations,
            "[G]oto [I]mplementation"
          )

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map(
            "gy",
            require("telescope.builtin").lsp_type_definitions,
            "Type [D]efinition"
          )

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map("<leader>cr", vim.lsp.buf.rename, "[R]ename")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
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

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map(
            "<leader>csd",
            require("telescope.builtin").lsp_document_symbols,
            "[D]ocument"
          )

          -- Fuzzy find all the symbols in your current workspace
          --  Similar to document symbols, except searches over your whole project.
          map(
            "<leader>csw",
            require("telescope.builtin").lsp_dynamic_workspace_symbols,
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

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
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

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        bashls = {},
        shellcheck = {},

        checkmake = {},

        asm_lsp = {},
        asmfmt = {},
        clangd = {
          on_attach = function(_)
            vim.keymap.set(
              "n",
              "<leader>ch",
              "<cmd>ClangdSwitchSourceHeader<cr>"
            )
          end,
        },

        basedpyright = {},
        ty = {},
        ruff = {},

        rust_analyzer = {},
        zls = {},
        nim_langserver = {},
        gopls = {},

        -- Java (eclipse)
        jdtls = {},
        jsonls = {},

        stylua = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                -- Tells lua_ls where to find all the Lua files that you have loaded
                -- for your neovim configuration.
                -- library = {
                --   "${3rd}/luv/library",
                --   unpack(vim.api.nvim_get_runtime_file("", true)),
                -- },
                -- If lua_ls is really slow on your computer, you can try this instead:
                library = { vim.env.VIMRUNTIME },
                telemetry = { enable = false },
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },

        prettier = {},
        yamlls = {
          on_attach = function(client, _)
            -- Formatting support needs to be forcibly enabled
            client.server_capabilities.documentFormattingProvider = true
          end,
          settings = {
            editor = {
              tabSize = 2,
            },
            yaml = {
              format = {
                enable = true,
                singleQuote = false,
              },
              validate = true,
              completion = true,
            },
            schemaStore = {
              enable = true,
            },
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            },
          },
          redhat = {
            telemetry = {
              enabled = false,
            },
          },
        },
        actionlint = {},
        helm_ls = {
          ["helm-ls"] = {
            yamlls = {
              path = "yaml-language-server",
            },
          },
        },
        terraformls = {},
        tflint = {},
        hclfmt = {},
      }

      require("mason-tool-installer").setup {
        ensure_installed = vim.tbl_keys(servers or {}),
      }

      require("mason-lspconfig").setup {
        ensure_installed = {},
        automatic_enable = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            require("lspconfig")[server_name].setup {
              cmd = server.cmd,
              settings = server.settings,
              filetypes = server.filetypes,
              capabilities = require("blink.cmp").get_lsp_capabilities(
                server.capabilities
              ),
              on_attach = server.on_attach,
            }
          end,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

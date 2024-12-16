return {
  { -- Autoformat
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    -- enabled = false,
    init = function()
      vim.api.nvim_create_user_command("AutoFormatDisable", function(args)
        if args.bang then
          vim.g.disable_autoformat = true
        else
          vim.b.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })
      vim.api.nvim_create_user_command("AutoFormatEnable", function(args)
        if args.bang then
          vim.g.disable_autoformat = false
        else
          vim.b.disable_autoformat = false
        end
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end,
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        -- yaml = { { "prettierd", "prettier" } },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
        html = { "prettier" },
        css = { "prettier" },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et

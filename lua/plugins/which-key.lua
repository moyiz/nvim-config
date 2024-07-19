-- NOTE: Plugins can also be configured to run lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VeryLazy'
--
-- which loads which-key after all the UI elements are loaded. Events can be
-- normal autocommands events (:help autocomd-events).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {
  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    -- enabled = false,
    event = "VeryLazy",
    config = function() -- This is the function that runs, AFTER loading
      -- vim.o.timeout = true
      -- vim.o.timeoutlen = 30
      require("which-key").setup {
        delay = 30,
      }

      -- Document existing key chains
      require("which-key").add {
        { "<leader>c", desc = "[C]ode" },
        { "<leader>cs", desc = "[S]ymbols" },
        { "<leader>s", desc = "[S]earch" },
        { "<leader>d", desc = "[D]ebug" },
        { "<leader>m", desc = "[M]ap" },
        { "<leader>t", desc = "[T]elescope" },
        { "<leader>g", desc = "[G]it" },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

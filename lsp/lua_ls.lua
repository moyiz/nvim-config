--  https://luals.github.io/wiki/settings/
return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        -- `lazydev.nvim` handles config-aware library paths; this is the floor.
        library = { vim.env.VIMRUNTIME },
      },
      telemetry = { enable = false },
      diagnostics = { disable = { "missing-fields" } },
    },
  },
}

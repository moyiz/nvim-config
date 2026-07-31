return {
  on_attach = function(client)
    -- yamlls does not advertise formatting unless it is forced on.
    client.server_capabilities.documentFormattingProvider = true
  end,
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      format = {
        enable = true,
        singleQuote = false,
      },
      validate = true,
      completion = true,
      schemaStore = { enable = true },
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
}

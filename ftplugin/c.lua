vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
vim.keymap.set(
  "n",
  "<leader>ch",
  "<cmd>LspClangdSwitchSourceHeader<cr>",
  { buffer = true }
)

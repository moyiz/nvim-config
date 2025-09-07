vim.lsp.inlay_hint.enable()
vim.keymap.set(
  "n",
  "<leader>ch",
  "<cmd>LspClangdSwitchSourceHeader<cr>",
  { buffer = true }
)

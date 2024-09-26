vim.api.nvim_create_user_command(
  "W",
  "w<bang> <args>",
  { bang = true, nargs = "*" }
)
vim.api.nvim_create_user_command(
  "Wa",
  "wa<bang> <args>",
  { bang = true, nargs = "*" }
)
vim.api.nvim_create_user_command(
  "Wqa",
  "wqa<bang> <args>",
  { bang = true, nargs = "*" }
)
vim.api.nvim_create_user_command(
  "Q",
  "q<bang> <args>",
  { bang = true, nargs = "*" }
)
vim.api.nvim_create_user_command(
  "Qa",
  "qa<bang> <args>",
  { bang = true, nargs = "*" }
)
vim.api.nvim_create_user_command(
  "X",
  "x<bang> <args>",
  { bang = true, nargs = "*" }
)
vim.api.nvim_create_user_command(
  "Xa",
  "xa<bang> <args>",
  { bang = true, nargs = "*" }
)

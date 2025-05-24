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
vim.api.nvim_create_user_command("CloseBuffersOthers", function()
  local current_dir = vim.fn.getcwd()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      local buf_dir = vim.fn.fnamemodify(buf_name, ":h")

      -- Check if the buffer's directory is not the current directory or a subdirectory
      if not buf_dir:find(current_dir, 1, true) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
end, {})

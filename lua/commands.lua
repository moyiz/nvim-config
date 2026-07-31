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
vim.api.nvim_create_user_command("BufferCloseOthers", function()
  local current_dir = vim.fs.normalize(vim.fn.getcwd())
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    -- Leave unnamed, scratch and terminal buffers alone.
    if
      vim.api.nvim_buf_is_loaded(buf)
      and buf_name ~= ""
      and vim.bo[buf].buftype == ""
    then
      local buf_dir = vim.fs.normalize(vim.fn.fnamemodify(buf_name, ":h"))
      local inside = buf_dir == current_dir
        or vim.startswith(buf_dir, current_dir .. "/")
      if not inside then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
end, { desc = "Close buffers outside the current working directory" })

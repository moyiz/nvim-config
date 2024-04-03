-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set(
  "n",
  "[d",
  vim.diagnostic.goto_prev,
  { desc = "Go to previous [D]iagnostic message" }
)
vim.keymap.set(
  "n",
  "]d",
  vim.diagnostic.goto_next,
  { desc = "Go to next [D]iagnostic message" }
)
vim.keymap.set(
  "n",
  "<leader>e",
  vim.diagnostic.open_float,
  { desc = "Show diagnostic [E]rror messages" }
)
vim.keymap.set(
  "n",
  "<leader>q",
  vim.diagnostic.setloclist,
  { desc = "Open diagnostic [Q]uickfix list" }
)

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set(
  "t",
  "<Esc><Esc>",
  "<C-\\><C-n>",
  { desc = "Exit terminal mode" }
)

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<leader>n", ":bn<cr>", { desc = "[N]ext buffer" })
vim.keymap.set("n", "<leader>p", ":bp<cr>", { desc = "[P]revious buffer" })

vim.keymap.set(
  "n",
  "<leader><left>",
  "<C-w>h",
  { desc = "Move focus to left window", remap = true }
)
vim.keymap.set(
  "n",
  "<leader><down>",
  "<C-w>j",
  { desc = "Move focus to lower window", remap = true }
)
vim.keymap.set(
  "n",
  "<leader><up>",
  "<C-w>k",
  { desc = "Move focus to upper window", remap = true }
)
vim.keymap.set(
  "n",
  "<leader><right>",
  "<C-w>l",
  { desc = "Move focus to right Window", remap = true }
)

-- [[ Basic Autocommands ]]
--  See :help lua-guide-autocommands

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup(
    "kickstart-highlight-yank",
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restore last cursor position in opened buffers
-- local lastplace = vim.api.nvim_create_augroup('LastPlace', {})
-- vim.api.nvim_clear_autocmds { group = lastplace }
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("LastPlace", {}),
  pattern = { "*" },
  desc = "remember last cursor place",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- vim: ts=2 sts=2 sw=2 et

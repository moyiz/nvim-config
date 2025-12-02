-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

-- Cmdline
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<Esc>b", "<S-Left>")
vim.keymap.set("c", "<Esc>f", "<S-Right>")

-- Remove highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- vim.keymap.set({ "n", "x" }, "g", "<Nop>") -- since no timeoutlen
vim.keymap.set({ "n", "x" }, "s", "<Nop>") -- since no timeoutlen
-- Commented out due to no timeoutlen
-- vim.keymap.set(
--   "t",
--   "<Esc><Esc>",
--   "<C-\\><C-n>",
--   { desc = "Exit terminal mode" }
-- )

vim.keymap.set("n", "<leader>n", ":bn<cr>", { desc = "[N]ext buffer" })
vim.keymap.set("n", "<leader>p", ":bp<cr>", { desc = "[P]revious buffer" })
vim.keymap.set("n", "<leader>bb", ":b#<cr>", { desc = "Last [B]uffer" })

-- Tabs
vim.keymap.set("n", "<leader>tn", ":tabn<cr>", { desc = "[N]ext [t]ab" })
vim.keymap.set("n", "<leader>tp", ":tabp<cr>", { desc = "[P]revious [t]ab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<cr>", { desc = "[C]lose [t]ab" })
vim.keymap.set("n", "<leader>t1", "1gt", { desc = "Go to [t]ab 1" })
vim.keymap.set("n", "<leader>t2", "2gt", { desc = "Go to [t]ab 2" })
vim.keymap.set("n", "<leader>t3", "3gt", { desc = "Go to [t]ab 3" })
vim.keymap.set("n", "<leader>t4", "4gt", { desc = "Go to [t]ab 4" })
vim.keymap.set("n", "<leader>t5", "5gt", { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>t6", "6gt", { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>t7", "7gt", { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>t8", "8gt", { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>t9", "9gt", { desc = "which_key_ignore" })

vim.keymap.set("n", "g.", function()
  local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  if not vim.uv.fs_stat(buf_name) then
    return
  end
  local cur_dir = vim.fs.dirname(buf_name)
  vim.notify("cwd: " .. cur_dir)
  vim.fn.chdir(cur_dir)
end, { desc = "Global CD to current buffer dirname" })

--  See `:help wincmd` for a list of all window commands
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
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { desc = "Normal mode" })

-- Replace in-word with math expression on it
vim.keymap.set(
  "n",
  "<leader>=",
  'ciw<C-r>=<C-r>"',
  { desc = "Replace current word with math expression" }
)

-- Show diff of current buffer and the actual file
vim.keymap.set(
  "n",
  "<leader>f",
  "<cmd>w !diff - %<CR>",
  { desc = "Diff buffer and [f]ile" }
)

vim.keymap.set("v", "<C-o>", function()
  -- get selected region
  -- if single line, rotate by words
  -- if multiple lines, rotate by lines
  -- overwrite selected region
  local mode = vim.fn.mode()

  local row_s, col_s = unpack(vim.api.nvim_win_get_cursor(0))
  row_s = row_s - 1

  local row_e, col_e = vim.fn.line "v" - 1, vim.fn.col "v" - 1

  if row_s == row_e then
    -- Cannot rotate a single line
    return
  end

  -- Cursor moved up, reverse `start` and `end`.
  if row_s > row_e then
    row_s, row_e = row_e, row_s
    col_s, col_e = col_e, col_s
  end

  local lines = vim.api.nvim_buf_get_lines(0, row_s, row_e + 1, false)
  if mode == "V" then -- rotate lines
    col_s = 0
    col_e = #vim.fn.getline(row_e + 1)
    table.insert(lines, 1, table.remove(lines))
  elseif mode == "\22" then -- rotate selected text in lines
    if col_s > col_e then
      col_s, col_e = col_e, col_s
    else
      col_e = col_e + 1
    end
    -- Get selections
    local selected = {}
    for _, line in pairs(lines) do
      if col_e <= #line then
        table.insert(selected, line:sub(col_s + 1, col_e))
      elseif col_s > #line then
        -- nothing
      else
        table.insert(
          selected,
          line:sub(col_s + 1) .. string.rep(" ", col_e - #line)
        )
      end
    end
    -- Rotate selections
    table.insert(selected, 1, table.remove(selected))

    -- Apply rotations to lines
    local j = 1
    for i, line in pairs(lines) do
      if #line > col_s then
        lines[i] = line:sub(1, col_s) .. selected[j] .. line:sub(col_e + 1)
        j = j + 1
      end
    end
  else
    col_e = col_e + 1
    local selected = { lines[1]:sub(col_s + 1) }
    for i = 2, #lines - 1 do
      table.insert(selected, lines[i])
    end
    table.insert(selected, lines[#lines]:sub(1, col_e))

    -- Rotate selections
    table.insert(selected, 1, table.remove(selected))

    -- Apply rotations to lines
    lines[1] = lines[1]:sub(1, col_s) .. selected[1]
    for i = 2, #lines - 1 do
      lines[i] = selected[i]
    end
    lines[#lines] = selected[#selected] .. lines[#lines]:sub(col_e + 1)
    -- TODO: Correct visual selection width on last line.
    --  Consider original cursor location.
  end
  vim.api.nvim_buf_set_lines(0, row_s, row_s + #lines, false, lines)
end, { desc = "Rotate selected text" })

-- [[ Basic Autocommands ]]
--  See :help lua-guide-autocommands

-- Highlight when yanking (copying) text
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup(
    "kickstart-highlight-yank",
    { clear = true }
  ),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Restore last cursor position in opened buffers
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

-- Help in a vertical split
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  callback = function()
    vim.opt_local.bufhidden = "unload"
    vim.cmd "wincmd L"
    vim.cmd "vert resize 81" -- Include scrollbar width
  end,
})

-- Disable features in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  command = "setlocal nospell",
})
-- vim: ts=2 sts=2 sw=2 et

-- [[ Setting options ]]
-- See `:help vim.opt`
-- See `:help option-list`

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = -1

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2"

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See :help 'list'
--  and :help 'listchars'
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Toggle cursor column with insert mode
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  callback = function()
    vim.opt.cursorcolumn = true
  end,
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = function()
    vim.opt.cursorcolumn = false
  end,
})

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Vertical line
-- vim.api.nvim_set_hl(0, "ColorColumn", {
--   ctermbg = 200,
--   fg = "#ffffff",
-- })

vim.opt.colorcolumn = "80"

vim.opt.background = "dark"

vim.opt.spell = true
vim.opt.spelloptions = "camel"

-- Command mode completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum"

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
vim.opt.foldminlines = 5

-- Auto-commands

-- Format options
-- Default: jcroql / cljrqo1
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt_local.formatoptions:remove { "o" } -- Do not insert comment for 'o' and 'O'
    vim.opt_local.formatoptions:append { "n" } -- Indent new lines in numbered lists
    vim.opt_local.formatoptions:append { "r" } -- Insert after <Enter>
  end,
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = { "*" },
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.api.nvim_command "startinsert"
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "wincmd ="
    vim.cmd "tabdo wincmd ="
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query", -- :InspectTree
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "close some filetype windows with <q>",
    })
  end,
})

local disabled_built_ins = {
  -- 'netrw',
  -- 'netrwPlugin',
  -- 'netrwSettings',
  -- 'netrwFileHandlers',
  -- "gzip",
  "zip",
  "zipPlugin",
  -- "tar",
  -- "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  -- "2html_plugin", -- :TOhtml
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
  -- Reduce startup time for python files
  -- /usr/share/nvim/runtime/autoload/provider/python3.vim
  "python3_provider",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
-- vim: ts=2 sts=2 sw=2 et

-- [[ Setting options ]]

vim.fn.setenv("MANWIDTH", "999")

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = -1

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"

-- Hide mode (already in status line)
vim.opt.showmode = false

-- cmdline overlays status line
-- vim.opt.cmdheight = 0

-- Single status line
vim.opt.laststatus = 3

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

vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Default border for every floating window that does not ask for its own,
-- instead of setting `border` per plugin.
vim.opt.winborder = "single"

-- Sets how neovim will display certain whitespace in the editor.
--  See :help 'list'
--  and :help 'listchars'
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions
vim.opt.inccommand = "split"

vim.opt.cursorline = true

-- Toggle cursor column with insert mode
local cursorcolumn_group =
  vim.api.nvim_create_augroup("user-cursorcolumn", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = cursorcolumn_group,
  callback = function()
    vim.opt_local.cursorcolumn = true
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = cursorcolumn_group,
  callback = function()
    vim.opt_local.cursorcolumn = false
  end,
})

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 7

vim.opt.colorcolumn = "80"

vim.opt.background = "dark"

vim.opt.spell = true
vim.opt.spelloptions = "camel"

-- Command mode completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum"

-- exrc
vim.opt.exrc = true

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
vim.opt.foldminlines = 5

-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-folds", { clear = true }),
  desc = "Prefer LSP folding ranges over treesitter where available",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method "textDocument/foldingRange" then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})

-- Format options
-- Default: jcroql / cljrqo1
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user-formatoptions", { clear = true }),
  desc = "Undo ftplugin comment-continuation defaults",
  callback = function()
    vim.opt_local.formatoptions:remove "o" -- Do not insert comment for 'o' and 'O'
    vim.opt_local.formatoptions:remove "r" -- Do not insert comment after <CR>
    vim.opt_local.formatoptions:append "n" -- Indent new lines in numbered lists
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("user-terminal", { clear = true }),
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.api.nvim_command "startinsert"
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("user-resize", { clear = true }),
  callback = function()
    vim.cmd "wincmd ="
    vim.cmd "tabdo wincmd ="
  end,
})

-- close some filetypes with <q>
local filetype_group =
  vim.api.nvim_create_augroup("user-filetype", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = filetype_group,
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

vim.api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = { "man" },
  callback = function()
    vim.keymap.set("n", "d", "<C-d>", {
      buffer = true,
      silent = true,
    })
    vim.keymap.set("n", "u", "<C-u>", {
      buffer = true,
      silent = true,
    })
    vim.keymap.set("n", "f", "<C-f>", {
      buffer = true,
      silent = true,
    })
    vim.keymap.set("n", "b", "<C-b>", {
      buffer = true,
      silent = true,
    })
    vim.keymap.set("n", "g", "gg", {
      buffer = true,
      silent = true,
      noremap = true,
    })
    vim.keymap.set("n", "q", "<cmd>q!<cr>", {
      buffer = true,
      silent = true,
    })
    -- vim.opt_local.laststatus = 0 -- global T_T
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
  "python3_provider",
  "ruby_provider",
  "perl_provider",
  "node_provider",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 0
end
-- vim: ts=2 sts=2 sw=2 et

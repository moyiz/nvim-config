-- [[ Setting options ]]

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = -1

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

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

-- Sets how neovim will display certain whitespace in the editor.
--  See :help 'list'
--  and :help 'listchars'
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions
vim.opt.inccommand = "split"

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
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method "textDocument/foldingRange" then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})
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

vim.api.nvim_create_autocmd("FileType", {
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
  "matchit",
  -- Reduce startup time for python files
  -- /usr/share/nvim/runtime/autoload/provider/python3.vim
  "python3_provider",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
-- vim: ts=2 sts=2 sw=2 et

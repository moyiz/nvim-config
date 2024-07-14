--[[
  Inspired by and diverged from: https://github.com/dam9000/kickstart-modular.nvim

  NOTE: Relevant docs:
    - https://learnxinyminutes.com/docs/lua/
    - :help lua-guide
    - https://neovim.io/doc/user/lua-guide.html
    - :Tutor

  NOTE: To search help: <leader>sh

  NOTE: For sanity check: `:checkhealth``
--]]

-- Set <space> as the leader key before loading plugins
-- See `:help mapleader`
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set clipboard manually to skip loading `clipboard.vim`
if vim.uv.os_uname().sysname == "Darwin" then
  vim.g.clipboard = {
    name = "bpcopy",
    copy = {
      ["+"] = "pbcopy -i",
      ["*"] = "pbcopy -i",
    },
    paste = {
      ["+"] = "pbpaste -i",
      ["*"] = "pbpaste -i",
    },
  }
else
  vim.g.clipboard = {
    name = "xsel",
    copy = {
      ["+"] = "xsel -ibp",
      ["*"] = "xsel -ibp",
    },
    paste = {
      ["+"] = "xsel -obp",
      ["*"] = "xsel -obp",
    },
    cache_enabled = 0,
  }
end

-- Enables the experimental Lua module loader
pcall(function()
  vim.loader.enable()
end)

-- [[ Setting options ]]
require "options"

-- [[ Basic Keymaps ]]
require "keymaps"

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require("lazy").setup {
  "dstein64/vim-startuptime",
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

  { "numToStr/Comment.nvim", opts = {} },

  {
    -- dir = "~/workspace/command-and-cursor.nvim",
    "moyiz/command-and-cursor.nvim",
    event = "VeryLazy",
    opts = {
      -- debug_position = true,
    },
  },

  { import = "plugins" },
}

-- See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

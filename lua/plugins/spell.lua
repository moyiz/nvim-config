return {
  {
    "psliwka/vim-dirtytalk",
    build = ":DirtytalkUpdate",
    config = function()
      vim.opt.spelllang = { "en", "programming" }
      vim.opt.rtp:append(vim.fn.stdpath "data" .. "/site")
    end,
  },
}

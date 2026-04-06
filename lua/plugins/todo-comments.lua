-- Highlight todo, notes, etc in comments
return {
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
      search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
      highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
    },
  },
}

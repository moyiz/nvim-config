return {
  "moyiz/git-dev.nvim",
  -- dir = "~/workspace/git-dev.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>go",
      function()
        local repo = vim.fn.input "Repository name / URI: "
        if repo ~= "" then
          require("git-dev").open(repo)
        end
      end,
      mode = "n",
      desc = "[O]pen a remote git repository",
    },
    -- {
    --   "<leader>o",
    --   function()
    --     local repo = vim.fn.getreg "*"
    --     if repo ~= "" then
    --       -- require("git-dev").open(repo)
    --       vim.notify("Repo: " .. repo)
    --     end
    --   end,
    --   mode = "v",
    --   desc = "[O]pen a remote git repository",
    -- },
  },
  opts = {
    cd_type = "tab",
    opener = function(dir)
      vim.cmd "tabnew"
      vim.cmd("NvimTreeOpen " .. vim.fn.fnameescape(dir))
    end,
    -- verbose = true,
  },
}

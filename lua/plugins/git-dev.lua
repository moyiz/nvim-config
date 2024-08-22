return {
  "moyiz/git-dev.nvim",
  -- dir = "~/workspace/git-dev.nvim",
  -- event = "VeryLazy",
  lazy = true,
  cmd = { "GitDevOpen", "GitDevToggleUI", "GitDevRecents", "GitDevCleanAll" },
  keys = {
    {
      "<leader>go",
      function()
        vim.ui.input({ prompt = "URI: " }, function(repo)
          if repo ~= "" then
            require("git-dev").open(repo)
          end
        end)
      end,
      mode = "n",
      desc = "[O]pen a remote git repository",
    },
    {
      "<leader>gr",
      "<cmd>GitDevRecents<cr>",
      mode = "n",
      desc = "[R]ecently opened git repositories",
    },
  },
  opts = {
    cd_type = "tab",
    opener = function(dir, _, selected_path)
      vim.cmd "tabnew"
      -- vim.cmd("Oil " .. vim.fn.fnameescape(dir))
      vim.cmd("edit " .. vim.fn.fnameescape(dir))
      if selected_path then
        vim.cmd("edit " .. selected_path)
      end
    end,
    verbose = true,
    extra_domain_to_parser = {
      ["git.home.arpa"] = function(parser, text, _)
        text = text:gsub("https://([^/]+)/(.*)$", "ssh://git@%1:2222/%2")
        return parser:parse_gitea_like_url(text, "ssh://git@git.home.arpa:2222")
      end,
    },
  },
}

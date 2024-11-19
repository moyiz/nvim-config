return {
  "moyiz/git-dev.nvim",
  -- dir = "~/workspace/git-dev.nvim",
  -- event = "VeryLazy",
  lazy = true,
  cmd = {
    "GitDevClean",
    "GitDevCleanAll",
    "GitDevCloseBuffers",
    "GitDevOpen",
    "GitDevRecents",
    "GitDevToggleUI",
  },
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
    {
      "<leader>gc",
      function()
        require("git-dev").close_buffers()
      end,
      mode = "n",
      desc = "[C]lose buffers of current repository",
    },
    {
      "<leader>gC",
      function()
        require("git-dev").clean()
      end,
      mode = "n",
      desc = "[C]lean current repository",
    },
  },
  opts = {
    cd_type = "tab",
    opener = function(dir, _, selected_path)
      vim.cmd "tabnew"
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

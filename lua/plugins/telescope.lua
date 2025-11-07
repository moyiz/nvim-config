return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- {
      --   "nvim-telescope/telescope-fzf-native.nvim",
      --   build = "make",
      --   cond = function()
      --     return vim.fn.executable "make" == 1
      --   end,
      -- },
      -- { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons" },
      -- { "nvim-telescope/telescope-live-grep-args.nvim" },
      -- { "nvim-telescope/telescope-symbols.nvim" },
    },
    config = function()
      -- Two important keymaps to use while in telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      require("telescope").setup {
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
        defaults = {
          file_ignore_patterns = {
            ".git/",
            "%.class",
            "^.zig-cache/",
            "^zig-out/",
          },
        },
      }

      local builtin = require "telescope.builtin"
      -- vim.keymap.set(
      --   "n",
      --   "<leader>tr",
      --   builtin.reloader,
      --   { desc = "[R]eloader" }
      -- )
      -- vim.keymap.set(
      --   "n",
      --   "<leader>sh",
      --   builtin.help_tags,
      --   { desc = "[S]earch [H]elp" }
      -- )
      -- vim.keymap.set(
      --   "n",
      --   "<leader>sk",
      --   builtin.keymaps,
      --   { desc = "[S]earch [K]eymaps" }
      -- )
      -- vim.keymap.set("n", "<leader>sf", function()
      --   return builtin.find_files { hidden = true }
      -- end, { desc = "[S]earch [F]iles" })
      vim.keymap.set(
        "n",
        "<leader>ss",
        builtin.builtin,
        { desc = "[S]earch [S]elect Telescope" }
      )
      -- vim.keymap.set("n", "<leader>sw", function()
      --   return builtin.grep_string { word_match = "-w" }
      -- end, { desc = "[S]earch current [W]ord" })
      -- vim.keymap.set(
      --   "n",
      --   "<leader>sg",
      --   -- builtin.live_grep,
      --   require("telescope").extensions.live_grep_args.live_grep_args,
      --   { desc = "[S]earch by [G]rep" }
      -- )
      -- vim.keymap.set(
      --   "n",
      --   "<leader>sd",
      --   builtin.diagnostics,
      --   { desc = "[S]earch [D]iagnostics" }
      -- )
      -- vim.keymap.set(
      --   "n",
      --   "<leader>sr",
      --   builtin.resume,
      --   { desc = "[S]earch [R]esume" }
      -- )
      -- vim.keymap.set(
      --   "n",
      --   "<leader>s.",
      --   builtin.oldfiles,
      --   { desc = '[S]earch Recent Files ("." for repeat)' }
      -- )
      vim.keymap.set(
        "n",
        "<leader>so",
        "<cmd>Telescope aerial<cr>",
        { desc = "[S]earch [O]utline (aerial)" }
      )
      -- vim.keymap.set(
      --   "n",
      --   "<leader><leader>",
      --   builtin.buffers,
      --   { desc = "[ ] Find existing buffers" }
      -- )
      -- vim.keymap.set(
      --   "n",
      --   "<leader>st",
      --   builtin.treesitter,
      --   { desc = "[S]earch [T]reesitter" }
      -- )
      -- vim.keymap.set(
      --   "n",
      --   "<leader>gm",
      --   builtin.git_bcommits,
      --   { desc = "[G]it Co[m]mits (buffer)" }
      -- )
      -- vim.keymap.set(
      --   "n",
      --   "<leader>gM",
      --   builtin.git_commits,
      --   { desc = "[G]it Co[m]mits (directory)" }
      -- )
      --[[
      - `<cr>`: checks out the currently selected branch
      - `<C-t>`: tracks currently selected branch
      - `<C-r>`: rebases currently selected branch
      - `<C-a>`: creates a new branch, with confirmation prompt before creation
      - `<C-d>`: deletes the currently selected branch, with confirmation
        prompt before deletion
      - `<C-y>`: merges the currently selected branch, with confirmation prompt
        before deletion
      ]]
      -- vim.keymap.set(
      --   "n",
      --   "<leader>gb",
      --   builtin.git_branches,
      --   { desc = "[G]it [B]ranches" }
      -- )

      -- vim.keymap.set("n", "<leader>tm", builtin.marks, { desc = "[M]arks" })

      -- vim.keymap.set(
      --   "n",
      --   "<leader>sp",
      --   builtin.registers,
      --   { desc = "[P]aste from register" }
      -- )
      --
      -- vim.keymap.set(
      --   "n",
      --   "<leader>tf",
      --   builtin.filetypes,
      --   { desc = "Set [F]iletype" }
      -- )

      -- vim.keymap.set("n", "<leader>/", function()
      --   builtin.current_buffer_fuzzy_find(
      --     require("telescope.themes").get_dropdown {
      --       winblend = 10,
      --       previewer = true,
      --     }
      --   )
      -- end, { desc = "[/] Fuzzily search in current buffer" })

      -- vim.keymap.set("n", "<leader>s/", function()
      --   builtin.live_grep {
      --     grep_open_files = true,
      --     prompt_title = "Live Grep in Open Files",
      --   }
      -- end, { desc = "[S]earch [/] in Open Files" })

      -- Shortcut for searching your neovim configuration files
      -- vim.keymap.set("n", "<leader>sn", function()
      --   builtin.find_files { cwd = vim.fn.stdpath "config" }
      -- end, { desc = "[S]earch [N]eovim files" })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

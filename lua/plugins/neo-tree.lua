return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = true,
  enabled = false,
  cmd = { "Neotree" },
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute {
          action = "focus",
          toggle = true,
          reveal = true,
        }
      end,
      mode = "n",
      desc = "File [E]xplorer",
    },
  },
  config = function()
    require("neo-tree").setup {
      window = {
        mappings = {
          -- Remap space to '.'
          ["<space>"] = "noop",
          ["."] = {
            "toggle_node",
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },

          -- Remap splits to use window-picker
          ["S"] = "noop",
          ["<c-h>"] = "split_with_window_picker",
          ["s"] = "noop",
          ["<c-v>"] = "vsplit_with_window_picker",

          -- Remap <CR> to use window-picker
          ["w"] = "noop",
          ["<cr>"] = "open_with_window_picker",
        },
      },
    }
  end,
}

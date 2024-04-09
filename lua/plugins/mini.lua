return {
  "echasnovski/mini.nvim",
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]parenthen
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup {
      mappings = {
        suffix_last = "", -- Causes keymap conflicts
        suffix_next = "", -- Causes keymap conflicts
      },
    }
    require("mini.statusline").setup()

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
    require("mini.indentscope").setup {
      -- symbol = '|',
      symbol = "▏",
      draw = {
        delay = 30,
      },
      options = {
        try_as_border = true,
      },
    }

    -- Inserts closing character for pairs
    -- require("mini.pairs").setup {
    --   modes = {
    --     command = true,
    --   },
    -- }

    --  overview of current buffer text.
    require("mini.map").setup()
    vim.keymap.set(
      "n",
      "<Leader>mc",
      require("mini.map").close,
      { desc = "[C]lose" }
    )
    vim.keymap.set(
      "n",
      "<Leader>mf",
      require("mini.map").toggle_focus,
      { desc = "Toggle [F]ocus" }
    )
    vim.keymap.set(
      "n",
      "<Leader>mo",
      require("mini.map").open,
      { desc = "[O]pen" }
    )
    vim.keymap.set(
      "n",
      "<Leader>mr",
      require("mini.map").refresh,
      { desc = "[R]efresh" }
    )
    vim.keymap.set(
      "n",
      "<Leader>ms",
      require("mini.map").toggle_side,
      { desc = "Toggle [S]ide" }
    )
    vim.keymap.set(
      "n",
      "<Leader>mt",
      require("mini.map").toggle,
      { desc = "[T]oggle" }
    )

    -- Highlight word under cursor
    require("mini.cursorword").setup {
      delay = 30,
    }

    -- Easymotion movements
    require("mini.jump2d").setup {
      labels = "tnresaio",
      view = {
        dim = true,
      },
      mappings = {
        start_jumping = "<leader><cr>",
      },
    }

    -- Set starter footer and refresh after `startuptime` is available
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniStarterOpened",
      callback = function()
        vim.api.nvim_create_autocmd("User", {
          pattern = "LazyVimStarted",
          callback = function()
            local starter = require "mini.starter"
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            starter.config.footer = function()
              return "⚡ Loaded plugins: "
                .. stats.loaded
                .. "/"
                .. stats.count
                .. "\n⚡ Startup time: "
                .. ms
                .. " ms"
            end
            starter.refresh()
          end,
        })
      end,
    })

    -- Starter
    local starter = require "mini.starter"

    -- Populate with workspaces from `workspaces.nvim` plugin
    local workspace_items = function()
      local workspaces = require "workspaces"
      local items = {}
      for _, w in pairs(workspaces.get()) do
        table.insert(items, {
          name = w.name .. " " .. w.path,
          action = "WorkspacesOpen " .. w.name,
          section = "Workspaces",
        })
      end
      return items
    end

    -- A workaround to make header truly centralized
    local centralize = function(content, buf_id)
      -- Get max line width, same as in `aligning`
      local max_line_width = math.max(unpack(vim.tbl_map(function(l)
        return vim.fn.strdisplaywidth(l)
      end, starter.content_to_lines(content))))

      -- Align
      content = starter.gen_hook.aligning("center", "center")(content, buf_id)

      -- Iterate over header items and pad with relative missing spaces
      local coords = starter.content_coords(content, "header")
      for _, c in ipairs(coords) do
        local unit = content[c.line][c.unit]
        local pad = (max_line_width - vim.fn.strdisplaywidth(unit.string)) / 2
        if unit.string ~= "" then
          unit.string = string.rep(" ", pad) .. unit.string
        end
      end
      return content
    end

    starter.setup {
      -- evaluate_single = true,
      header = "███████████████████████████\n"
        .. "███████▀▀▀░░░░░░░▀▀▀███████\n"
        .. "████▀░░░░░░░░░░░░░░░░░▀████\n"
        .. "███│░░░░░░░░░░░░░░░░░░░│███\n"
        .. "██▌│░░░░░░░░░░░░░░░░░░░│▐██\n"
        .. "██░└┐░░░░░░░░░░░░░░░░░┌┘░██\n"
        .. "██░░└┐░░░░░░░░░░░░░░░┌┘░░██\n"
        .. "██░░┌┘▄▄▄▄▄░░░░░▄▄▄▄▄└┐░░██\n"
        .. "██▌░│██████▌░░░▐██████│░▐██\n"
        .. "███░│▐███▀▀░░▄░░▀▀███▌│░███\n"
        .. "██▀─┘░░░░░░░▐█▌░░░░░░░└─▀██\n"
        .. "██▄░░░▄▄▄▓░░▀█▀░░▓▄▄▄░░░▄██\n"
        .. "████▄─┘██▌░░░░░░░▐██└─▄████\n"
        .. "█████░░▐█─┬┬┬┬┬┬┬─█▌░░█████\n"
        .. "████▌░░░▀┬┼┼┼┼┼┼┼┬▀░░░▐████\n"
        .. "█████▄░░░└┴┴┴┴┴┴┴┘░░░▄█████\n"
        .. "███████▄░░░░░░░░░░░▄███████\n"
        .. "██████████▄▄▄▄▄▄▄██████████\n",

      items = {
        workspace_items,
        starter.sections.recent_files(10, false),
        { section = "Tools", name = "Lazy", action = "Lazy" },
        { section = "Tools", name = "Telescope", action = "Telescope" },
        starter.sections.builtin_actions(),
      },
      content_hooks = {
        centralize,
        starter.gen_hook.adding_bullet(),
      },
    }
  end,
}
-- vim: ts=2 sts=2 sw=2 et

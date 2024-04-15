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

    -- Diff
    require("mini.diff").setup()
    vim.keymap.set(
      "n",
      "<leader>gd",
      require("mini.diff").toggle_overlay,
      { desc = "Show inline [D]iff" }
    )

    -- overview of current buffer text.
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
          name = w.name .. " " .. vim.fn.fnamemodify(w.path, ":~:."),
          action = "WorkspacesOpen " .. w.name,
          section = "Workspaces",
        })
      end
      return items
    end

    -- A workaround to centralize everything.
    -- `aligning("center", "center")` will centralize the longest line in
    -- `content`, then left align other items to its beginning.
    -- It causes the header to not be truly centralized and have a variable
    -- shift to the left.
    -- This function will use `aligning` and pad the header accordingly.
    -- It also goes over `justified_sections`, goes over all their items names
    -- and justifies them by padding existing space in them.
    local centralize = function(justified_sections, centralize_header)
      return function(content, buf_id)
        -- Get max line width, same as in `aligning`
        local max_line_width = math.max(unpack(vim.tbl_map(function(l)
          return vim.fn.strdisplaywidth(l)
        end, starter.content_to_lines(content))))

        -- Align
        content = starter.gen_hook.aligning("center", "center")(content, buf_id)

        -- Iterate over header items and pad with relative missing spaces
        if centralize_header == true then
          local coords = starter.content_coords(content, "header")
          for _, c in ipairs(coords) do
            local unit = content[c.line][c.unit]
            local pad = (max_line_width - vim.fn.strdisplaywidth(unit.string))
              / 2
            if unit.string ~= "" then
              unit.string = string.rep(" ", pad) .. unit.string
            end
          end
        end

        -- Justify recent files and workspaces
        if justified_sections ~= nil and #justified_sections > 0 then
          local coords = starter.content_coords(content, "item")
          for _, c in ipairs(coords) do
            local unit = content[c.line][c.unit]
            if vim.tbl_contains(justified_sections, unit.item.section) then
              local one, two = unpack(vim.split(unit.string, " "))
              unit.string = one
                .. string.rep(
                  " ",
                  max_line_width - vim.fn.strdisplaywidth(unit.string) + 1
                )
                .. two
            end
          end
        end
        return content
      end
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
        .. "██████████▄▄▄▄▄▄▄██████████\n"
        .. "pwd: "
        .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~:."),

      items = {
        workspace_items,
        starter.sections.recent_files(10, false, function(path)
          -- Bring back trailing slash after `dirname`
          return " " .. vim.fn.fnamemodify(path, ":~:.:h") .. "/"
        end),
        { section = "Tools", name = "Lazy", action = "Lazy" },
        { section = "Tools", name = "Telescope", action = "Telescope" },
        starter.sections.builtin_actions(),
      },
      content_hooks = {
        -- starter.gen_hook.adding_bullet(),
        centralize({ "Recent files", "Workspaces" }, true),
      },
    }

    -- Enable if it can be disabled for git-dev.nvim
    -- vim.api.nvim_create_autocmd("TabNewEntered", {
    --   callback = function()
    --     starter.open()
    --   end,
    -- })
  end,
}
-- vim: ts=2 sts=2 sw=2 et

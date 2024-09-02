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

    local animate = require "mini.animate"
    animate.setup {
      cursor = { enable = false },
      scroll = {
        timing = animate.gen_timing.cubic { duration = 100, unit = "total" },
      },
    }

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

    require("mini.indentscope").setup {
      symbol = "▏",
      draw = {
        delay = 30,
      },
      options = {
        try_as_border = true,
      },
    }

    -- Files
    local files = require "mini.files"
    files.setup {
      windows = {
        preview = true,
        width_preview = 80,
      },
      mappings = {
        close = "",
        go_in = "",
        go_in_plus = "",
        go_out = "",
        go_out_plus = "",
        -- reset = "<BS>",
        -- reveal_cwd = "@",
        -- show_help = "g?",
        -- synchronize = "=",
        -- trim_left = "<",
        -- trim_right = ">",
      },
    }

    vim.keymap.set("n", "<Leader>e", function()
      if not files.close() then
        local path = vim.api.nvim_buf_get_name(0)
        if vim.fn.exists(path) ~= 0 then
          path = "."
        end
        files.open(path, false)
        files.reveal_cwd()
      end
    end, { desc = "File [E]xplorer" })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local set = function(rhs, lhs)
          local rhs_array
          if vim.isarray(rhs) then
            rhs_array = rhs
          else
            rhs_array = { rhs }
          end
          for _, r in ipairs(rhs_array) do
            vim.keymap.set("n", r, lhs, { buffer = args.data.buf_id })
          end
        end

        -- window picker helper
        local _pick_window = function()
          local fs_entry = MiniFiles.get_fs_entry()
          if fs_entry ~= nil and fs_entry.fs_type == "file" then
            -- Toggle `MiniFiles` so `window-picker` will be visible.
            MiniFiles.close()
            local win_id = require("window-picker").pick_window()
            MiniFiles.open(fs_entry.path)
            return win_id
          end
        end

        -- Select target window with `window-picker`
        local go_in_window_picker = function(go_in_args)
          local win_id = _pick_window()
          if win_id then
            MiniFiles.set_target_window(win_id)
          end
          MiniFiles.go_in(go_in_args)
        end

        -- Open file in a new split with `window-picker`
        local split = function(direction, go_in_args)
          local win_id = _pick_window()
          if win_id then
            local new_target_window
            vim.api.nvim_win_call(win_id, function()
              vim.cmd(direction .. " split")
              new_target_window = vim.api.nvim_get_current_win()
            end)
            MiniFiles.set_target_window(new_target_window)
            MiniFiles.go_in(go_in_args)
          end
        end

        -- CD to directory of current file
        local cd_current = function()
          local win_id = MiniFiles.get_target_window()
          if not win_id then
            return
          end
          local buf_name =
            vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win_id))
          if vim.fn.exists(buf_name) ~= 0 then
            return
          end
          local cur_dir = vim.fs.dirname(buf_name)
          vim.notify("cwd: " .. cur_dir)
          vim.fn.chdir(cur_dir)
          MiniFiles.reset()
        end

        set({ "q", "<esc>" }, files.close)
        -- set({ "l", "<right>" }, files.go_in)
        set({ "l", "<right>" }, go_in_window_picker)
        set({ "L", "<S-right>", "<CR>" }, function()
          for _ = 1, vim.v.count1 do
            -- files.go_in { close_on_file = true }
            go_in_window_picker { close_on_file = true }
          end
        end)
        set({ "h", "<left>" }, files.go_out)
        set({ "H", "<S-left>", "<S-CR>" }, function()
          for _ = 1, vim.v.count1 do
            files.go_out()
          end
          files.trim_right()
        end)
        set({ "<C-v>" }, function()
          split "belowright vertical"
        end)
        set({ "<C-h>" }, function()
          split "belowright horizontal"
        end)
        set({ "z" }, cd_current)
      end,
    })

    -- For telescope to not auto-close when mini.files closes
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        local ft = vim.bo.filetype
        if ft == "minifiles" or ft == "minifiles-help" then
          return
        end
        local cur_win_id = vim.api.nvim_get_current_win()
        MiniFiles.close()
        pcall(vim.api.nvim_set_current_win, cur_win_id)
      end,
      desc = "Close 'mini.files' on lost focus",
    })

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
      "<Leader>mf",
      require("mini.map").toggle_focus,
      { desc = "Toggle [F]ocus" }
    )
    vim.keymap.set(
      "n",
      "<Leader>mr",
      require("mini.map").refresh,
      { desc = "[R]efresh" }
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

    -- Bracket jumps
    require("mini.bracketed").setup {}

    -- Split and join arguments
    require("mini.splitjoin").setup {}

    -- Extend f, F, t, T
    require("mini.jump").setup {}

    -- Easymotion movements
    jump2d = require "mini.jump2d"
    jump2d.setup {
      labels = "tnresaio",
      spotter = jump2d.builtin_opts.word_start.spotter,
      view = {
        n_steps_ahead = 5,
      },
      mappings = {
        start_jumping = "<leader><cr>",
      },
    }

    require("mini.trailspace").setup {}

    require("mini.icons").setup {}

    -- Set starter footer and refresh after `startuptime` is available
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
        -- https://github.com/LazyVim/LazyVim/commit/dc66887b57ecdee8d33b5e07ca031288260e2971
        vim.cmd [[do VimResized]]
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
    -- Since `item_bullet` are separated from the items themselves, their
    -- width is measured separately and deducted from the padding.
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
          -- Check if `adding_bullet` has mutated the `content`
          local coords = starter.content_coords(content, "item_bullet")
          local bullet_len = 0
          if coords ~= nil then
            -- Bullet items are defined, compensate for bullet prefix width
            bullet_len = vim.fn.strdisplaywidth(
              content[coords[1].line][coords[1].unit].string
            )
          end

          coords = starter.content_coords(content, "item")
          for _, c in ipairs(coords) do
            local unit = content[c.line][c.unit]
            if vim.tbl_contains(justified_sections, unit.item.section) then
              local one, two = unpack(vim.split(unit.string, " "))
              unit.string = one
                .. string.rep(
                  " ",
                  max_line_width
                    - vim.fn.strdisplaywidth(unit.string)
                    - bullet_len
                    + 1
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
        starter.gen_hook.adding_bullet(),
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

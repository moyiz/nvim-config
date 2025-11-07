return {
  "nvim-mini/mini.nvim",
  version = false,
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]parenthen
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    local ai = require "mini.ai"
    ai.setup {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }, {}),
        f = ai.gen_spec.treesitter(
          { a = "@function.outer", i = "@function.inner" },
          {}
        ),
        c = ai.gen_spec.treesitter(
          { a = "@class.outer", i = "@class.inner" },
          {}
        ),
      },
    }

    require("mini.bufremove").setup {}
    vim.keymap.set("n", "<leader>bd", function()
      require("mini.bufremove").delete(0, false)
    end, { desc = "[B]uffer [D]elete" })
    vim.keymap.set("n", "<leader>bD", function()
      require("mini.bufremove").delete(0, true)
    end, { desc = "[B]uffer [D]elete (force)" })
    vim.keymap.set("n", "<leader>bw", function()
      require("mini.bufremove").wipeout(0, false)
    end, { desc = "[B]uffer [W]ipeout" })
    vim.keymap.set("n", "<leader>bW", function()
      require("mini.bufremove").wipeout(0, true)
    end, { desc = "[B]uffer [W]ipeout (force)" })

    local clue = require "mini.clue"
    clue.setup {
      triggers = {
        -- Leader triggers
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        -- `[` and `]` keys
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
        -- Built-in completion
        { mode = "i", keys = "<C-x>" },
        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        -- Marks
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },
        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
        -- Window commands
        { mode = "n", keys = "<C-w>" },
        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
      },
      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        clue.gen_clues.square_brackets(),
        clue.gen_clues.builtin_completion(),
        clue.gen_clues.g(),
        clue.gen_clues.marks(),
        clue.gen_clues.registers(),
        clue.gen_clues.windows(),
        clue.gen_clues.z(),
        { mode = "n", keys = "<leader>b", desc = "[B]uffers" },
        { mode = "n", keys = "<leader>c", desc = "[C]ode" },
        { mode = "n", keys = "<leader>cs", desc = "[S]ymbols" },
        { mode = "n", keys = "<leader>s", desc = "[S]earch" },
        { mode = "n", keys = "<leader>d", desc = "[D]ebug" },
        { mode = "n", keys = "<leader>m", desc = "[M]ap" },
        { mode = "n", keys = "<leader>t", desc = "[T]elescope" },
        { mode = "n", keys = "<leader>g", desc = "[G]it" },
      },
      window = {
        delay = 30,
        config = {
          width = "auto",
        },
      },
    }

    require("mini.extra").setup {}
    -- local ui_select = vim.ui.select
    require("mini.pick").setup {
      mappings = {
        choose_in_split = "<C-h>",
        scroll_left = "<S-Left>",
        scroll_down = "<S-Down>",
        scroll_up = "<S-Up>",
        scroll_right = "<S-Right>",
      },
      options = {
        content_from_bottom = false,
        use_cache = false,
      },
      window = {
        config = function()
          return {
            -- anchor = "NW",
            -- relative = "editor",
            -- col = 0,
            width = math.max(80, math.floor(vim.o.columns * 0.8)),
            height = math.max(20, math.floor(vim.o.lines * 0.40)),
          }
        end,
      },
    }
    -- vim.ui.select = ui_select

    -- window-picker for files picker
    local _pick_window_picker = function(pre_cmd)
      return function()
        local match = MiniPick.get_picker_matches()
        local win_id = require("window-picker").pick_window()
        if win_id then
          vim.api.nvim_win_call(win_id, function()
            if pre_cmd then
              vim.cmd(pre_cmd)
            end
            if match then
              vim.cmd("edit " .. match.current)
            end
          end)
          return true
        end
        return false
      end
    end

    local files_opts = {
      mappings = {
        choose = "",
        choose_in_split = "",
        choose_in_vsplit = "",
        pick = {
          char = "<cr>",
          func = _pick_window_picker(),
        },
        pick_in_split = {
          char = "<C-h>",
          func = _pick_window_picker "split",
        },
        pick_in_vsplit = {
          char = "<C-v>",
          func = _pick_window_picker "vsplit",
        },
      },
    }

    vim.keymap.set("n", "<leader>gf", function()
      -- when to pick cwd and when buffer's path?
      local cwd = vim.fn.getcwd()
      local repo_dir = vim.fn.systemlist({
        "git",
        "-C",
        cwd,
        "rev-parse",
        "--show-toplevel",
      })[1]
      if vim.v.shell_error ~= 0 then
        vim.notify(
          "'" .. cwd .. "' is not a git repository",
          vim.log.levels.ERROR
        )
        return
      end
      MiniExtra.pickers.git_files({ path = repo_dir }, files_opts)
    end, { desc = "[G]it [F]iles" })

    vim.keymap.set("n", "<leader>sf", function()
      MiniPick.builtin.files(nil, files_opts)
    end, { desc = "[S]earch [F]iles" })

    vim.keymap.set(
      "n",
      "<leader>sr",
      MiniPick.builtin.resume,
      { desc = "[S]earch [R]esume" }
    )

    vim.keymap.set("n", "<leader>sd", function()
      MiniExtra.pickers.diagnostic {
        -- scope = "current",
      }
    end, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>s.", function()
      MiniExtra.pickers.oldfiles {
        -- current_dir = true,
        -- preserve_order = true,
      }
    end, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set("n", "<leader><leader>", function()
      MiniPick.builtin.buffers({
        -- include_current = false,
        -- include_unlisted = true,
      }, {
        mappings = {
          wipeout = {
            char = "<C-d>",
            func = function()
              vim.api.nvim_buf_delete(
                MiniPick.get_picker_matches().current.bufnr,
                {}
              )
            end,
          },
        },
      })
    end, { desc = "[ ] Find existing buffers" })
    vim.keymap.set(
      "n",
      "<leader>sk",
      MiniExtra.pickers.keymaps,
      { desc = "[S]earch [K]eymaps" }
    )
    vim.keymap.set(
      "n",
      "<leader>sh",
      MiniPick.builtin.help,
      { desc = "[S]earch [H]elp" }
    )
    vim.keymap.set("n", "<leader>/", function()
      MiniExtra.pickers.buf_lines {
        scope = "current",
        -- preserve_order = true,
      }
    end, { desc = "[/] Fuzzily search in current buffer" })
    vim.keymap.set("n", "<leader>sg", function()
      -- Use `<C-o>` custom mapping to add glob to the array.
      MiniPick.builtin.grep_live()
    end, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sw", function()
      MiniPick.builtin.grep {
        pattern = vim.fn.expand "<cword>",
      }
    end, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sn", function()
      MiniPick.builtin.files(nil, {
        source = {
          cwd = vim.fn.stdpath "config",
        },
      })
    end, { desc = "[S]earch [N]eovim files" })
    vim.keymap.set("n", "<leader>st", function()
      MiniExtra.pickers.lsp {
        -- "declaration".
        -- "definition".
        -- "document_symbol".
        -- "implementation".
        -- "references".
        -- "type_definition".
        -- "workspace_symbol".
        scope = "document_symbol",
      }
    end, { desc = "[S]earch [T]reesitter" })
    vim.keymap.set("n", "<leader>gm", function()
      MiniExtra.pickers.git_commits {
        path = vim.fn.expand "%",
      }
    end, { desc = "[G]it Co[m]mits (buffer)" })
    vim.keymap.set("n", "<leader>gM", function()
      MiniExtra.pickers.git_commits {
        path = ".",
      }
    end, { desc = "[G]it Co[m]mits (directory)" })
    vim.keymap.set("n", "<leader>gb", function()
      MiniExtra.pickers.git_branches {}
    end, { desc = "[G]it [B]ranches" })
    vim.keymap.set("n", "<leader>sy", function()
      MiniExtra.pickers.registers {}
    end, { desc = "[S]earch Registers ([y]ank)" })
    vim.keymap.set("n", "<leader>si", function()
      MiniExtra.pickers.hl_groups {}
    end, { desc = "[S]earch H[i]ghlight groups" })

    vim.keymap.set("n", "<leader>tm", function()
      MiniExtra.pickers.marks {}
    end, { desc = "[M]arks" })

    vim.keymap.set("n", "<leader>,c", function()
      MiniExtra.pickers.colorschemes()
    end, { desc = "[C]olorscheme" })

    vim.keymap.set("n", "<leader>sp", function()
      local items = vim.tbl_keys(MiniPick.registry)
      table.sort(items)
      local source =
        { items = items, name = "Registry", choose = function() end }
      local chosen_picker_name = MiniPick.start { source = source }
      if chosen_picker_name == nil then
        return
      end
      return MiniPick.registry[chosen_picker_name]()
    end, { desc = "[S]earch [P]ickers" })

    local ns_id = vim.api.nvim_create_namespace "stam"
    vim.keymap.set("n", "<leader>sm", function()
      local topic_section = function(item)
        local _, _, topic, section = item:find "([%w%-%_%:%.%@]+)%s+%((%w+)%)"
        return topic, section
      end
      MiniPick.builtin.cli({
        command = { "man", "-k", ".*" },
        postprocess = function(lines)
          lines = vim.tbl_filter(function(line)
            return line ~= ""
          end, lines)
          table.sort(lines, function(a, b)
            return a < b
          end)
          return lines
        end,
      }, {
        source = {
          show = function(buf_id, items_to_show, query)
            MiniPick.default_show(buf_id, items_to_show, query, nil)
            for i, line in ipairs(items_to_show) do
              -- local topic, section = topic_section(line)
              vim.api.nvim_buf_set_extmark(buf_id, ns_id, i - 1, 0, {
                end_col = 0,
                end_row = i,
                hl_mode = "blend",
                -- TODO:
                -- hl_group = "Tag",
              })
            end
            -- return MiniPick.default_show(buf_id, items_to_show, query, nil)
          end,
          choose = function(item)
            if item == nil then
              return
            end
            local topic, section = topic_section(item)
            vim.schedule(function()
              vim.cmd("Man " .. section .. " " .. topic)
              vim.cmd "setlocal nospell"
            end)
          end,
          preview = function(buf_id, item)
            vim.api.nvim_buf_call(buf_id, function()
              vim.bo.buftype, vim.bo.buflisted, vim.bo.bufhidden =
                "nofile", false, "wipe"
              local has_ts = pcall(vim.treesitter.start, 0)
              if not has_ts then
                vim.bo.syntax = "man"
              end
              local topic, section = topic_section(item)
              vim.cmd(
                "read !MANROFFOPT='-W font -W break' man --pager=cat "
                  .. section
                  .. " "
                  .. topic
              )
              vim.cmd "normal! gg"
              vim.cmd "normal! dd" -- remove blank line
              vim.cmd "setlocal nospell"
              -- vim.cmd "normal! zt"
            end)
          end,
        },
      })
    end, { desc = "[S]earch [M]an pages" })

    require("mini.align").setup {}

    require("mini.fuzzy").setup {}

    require("mini.notify").setup {
      content = {
        format = function(notif)
          -- local time = vim.fn.strftime("%H:%M:%S", math.floor(notif.ts_update))
          return string.format("%s │ %s", notif.level, notif.msg)
        end,
      },
      lsp_progress = {
        enable = false,
      },
      window = {
        winblend = 50,
        config = function()
          return {
            anchor = "NW",
            relative = "cursor",
            col = 80,
            title = "",
            -- width = 40,
            -- height = 8,
          }
        end,
      },
    }
    vim.notify = MiniNotify.make_notify {
      ERROR = { duration = 15000 },
    }

    require("mini.animate").setup {
      cursor = { enable = false },
      resize = { enable = false },
      scroll = {
        enable = false,
        -- timing = animate.gen_timing.cubic { duration = 100, unit = "total" },
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

    -- require("mini.tabline").setup {
    --   tabpage_section = "right",
    --   format = function(buf_id, label)
    --     local suffix = vim.bo[buf_id].modified and "➕  " or ""
    --     return MiniTabline.default_format(buf_id, label) .. suffix
    --   end,
    -- }

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
    require("mini.files").setup {
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
      if not MiniFiles.close() then
        local path = vim.api.nvim_buf_get_name(0)
        if not vim.uv.fs_stat(path) then
          local dir = vim.fs.dirname(path)
          if vim.uv.fs_stat(dir) then
            path = dir
          else
            path = "."
          end
        end
        MiniFiles.open(path, false)
        MiniFiles.reveal_cwd()
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
            if win_id then
              MiniFiles.open(fs_entry.path)
              MiniFiles.set_target_window(win_id)
            end
            return win_id
          end
        end

        -- Select target window with `window-picker`
        local go_in_window_picker = function(go_in_args)
          _pick_window()
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

        local cd_current_dir = function()
          local cur_entry_path = MiniFiles.get_fs_entry().path
          local cur_dir = vim.fs.dirname(cur_entry_path)
          vim.notify("cwd: " .. cur_dir)
          vim.fn.chdir(cur_dir)
        end

        set({ "q", "<esc>" }, MiniFiles.close)
        -- set({ "l", "<right>" }, files.go_in)
        set({ "l", "<right>" }, go_in_window_picker)
        set({ "L", "<S-right>", "<CR>" }, function()
          for _ = 1, vim.v.count1 do
            -- files.go_in { close_on_file = true }
            go_in_window_picker { close_on_file = true }
          end
        end)
        set({ "h", "<left>" }, MiniFiles.go_out)
        set({ "H", "<S-left>", "<S-CR>" }, function()
          for _ = 1, vim.v.count1 do
            MiniFiles.go_out()
          end
          MiniFiles.trim_right()
        end)
        set({ "<C-v>" }, function()
          split("belowright vertical", { close_on_file = true })
        end)
        set({ "<C-h>" }, function()
          split("belowright horizontal", { close_on_file = true })
        end)
        set({ "g." }, cd_current_dir)
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
    vim.keymap.set(
      "n",
      "<Leader>J",
      require("mini.splitjoin").toggle,
      { desc = "Split / Join" }
    )

    -- Extend f, F, t, T
    require("mini.jump").setup {}

    -- Easymotion movements
    local jump2d = require "mini.jump2d"
    jump2d.setup {
      labels = "tnresaioluc,dh",
      -- spotter = jump2d.builtin_opts.word_start.spotter,
      -- spotter = jump2d.gen_spotter.vimpattern "[A-Z]*[a-z0-9]\\+",
      spotter = jump2d.gen_spotter.vimpattern "[A-Za-z0-9]\\+",
      view = {
        n_steps_ahead = 5,
      },
      mappings = {
        start_jumping = "<leader><cr>",
      },
    }
    -- vim.api.nvim_set_hl(0, "MiniJump2dSpot", { reverse = true })
    vim.api.nvim_set_hl(0, "MiniJump2dSpot", {
      nocombine = true,
      fg = "White",
      bg = "#aa0000",
    })

    vim.api.nvim_set_hl(0, "MiniJump2dSpotAhead", {
      nocombine = true,
      fg = "White",
      bg = "Black",
    })

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
        { section = "Tools", name = "Mason", action = "Mason" },
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

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = true,
  cmd = {
    "NvimTreeOpen",
    "NvimTreeToggle",
    "NvimTreeRefresh",
    "NvimTreeFindFile",
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>e",
      function()
        require("nvim-tree.api").tree.toggle { focus = true, find_file = true }
      end,
      mode = "n",
      silent = true,
      desc = "Toggle Tree",
    },
  },
  init = function()
    local autocmd = vim.api.nvim_create_autocmd

    autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
      pattern = "NvimTree_*",
      callback = function()
        local layout = vim.api.nvim_call_function("winlayout", {})
        if
          layout[1] == "leaf"
          and vim.api.nvim_buf_get_option(
            vim.api.nvim_win_get_buf(layout[2]),
            "filetype"
          ) == "NvimTree"
          and layout[3] == nil
        then
          vim.cmd "confirm quit"
        end
      end,
    })

    -- when no file/directory is opened at startup
    -- skip nvim-tree so that dashboard can load
    if vim.fn.argc(-1) == 0 then
      return
    else
      autocmd({ "VimEnter" }, {
        -- open nvim-tree for noname buffers and directory
        callback = function(args)
          -- buffer is a [No Name]
          local no_name = args.file == "" and vim.bo[args.buf].buftype == ""
          -- buffer is a directory
          local directory = vim.fn.isdirectory(args.file) == 1

          if not directory and not no_name then
            return
          end

          local api = require "nvim-tree.api"

          if directory then
            -- change to the directory
            vim.cmd.cd(args.file)
            -- open the tree
            api.tree.open()
          else
            -- open the tree, find the file but don't focus it
            api.tree.toggle { focus = false, find_file = true }
          end
        end,
      })
    end
  end,
  opts = function(_, _)
    local function on_attach(bufnr)
      local api = require "nvim-tree.api"

      local function opts(desc)
        return {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
      end
      local map = vim.keymap.set

      map("n", "g?", api.tree.toggle_help, opts "Help")

      map("n", "<C-]>", api.tree.change_root_to_node, opts "CD")
      map("n", "C", api.tree.change_root_to_node, opts "CD")

      map("n", "E", api.tree.expand_all, opts "Expand All")
      map("n", "q", api.tree.close, opts "Close")
      map("n", "R", api.tree.reload, opts "Refresh")
      map("n", "S", api.tree.search_node, opts "Search")
      map("n", "U", api.tree.toggle_custom_filter, opts "Toggle Hidden")
      map("n", "H", api.tree.toggle_hidden_filter, opts "Toggle Dotfiles")
      map("n", "W", api.tree.collapse_all, opts "Collapse")

      map(
        "n",
        "<C-e>",
        api.node.open.replace_tree_buffer,
        opts "Open: In Place"
      )
      map("n", "<CR>", api.node.open.edit, opts "Open")
      map("n", "o", api.node.open.edit, opts "Open")
      map(
        "n",
        "O",
        api.node.open.no_window_picker,
        opts "Open: No Window Picker"
      )

      map("n", "<C-k>", api.node.show_info_popup, opts "File Info")

      map("n", "<C-r>", api.fs.rename_sub, opts "Rename: Omit Filename")
      map("n", "e", api.fs.rename_basename, opts "Rename: Basename")
      map("n", "r", api.fs.rename, opts "Rename File")
      map("n", "a", api.fs.create, opts "Create File")
      map("n", "c", api.fs.copy.node, opts "Copy File")
      map("n", "y", api.fs.copy.filename, opts "Copy Name")
      map("n", "Y", api.fs.copy.relative_path, opts "Copy Relative Path")
      map("n", "gy", api.fs.copy.absolute_path, opts "Copy Absolute Path")
      map("n", "d", api.fs.remove, opts "Delete")
      map("n", "D", api.fs.trash, opts "Trash")
      map("n", "p", api.fs.paste, opts "Paste")
      map("n", "x", api.fs.cut, opts "Cut")

      map("n", "<C-v>", api.node.open.vertical, opts "Open: Vertical Split")
      map("n", "<C-h>", api.node.open.horizontal, opts "Open: Horizontal Split")
      map("n", "<C-t>", api.node.open.tab, opts "Open: New Tab")

      map("n", "<BS>", api.node.navigate.parent_close, opts "Close Directory")

      map("n", "<Tab>", api.node.open.preview, opts "Open Preview")

      map("n", ">", api.node.navigate.sibling.next, opts "Next Sibling")
      map("n", "<", api.node.navigate.sibling.prev, opts "Previous Sibling")
      map("n", "J", api.node.navigate.sibling.last, opts "Last Sibling")
      map("n", "K", api.node.navigate.sibling.first, opts "First Sibling")
      map("n", "P", api.node.navigate.parent, opts "Parent Directory")
      map("n", "-", api.tree.change_root_to_parent, opts "Up")

      map("n", ".", api.node.run.cmd, opts "Run File Command")
      map("n", "s", api.node.run.system, opts "Run System")

      map("n", "bmv", api.marks.bulk.move, opts "Move Bookmarked")
      map("n", "m", api.marks.toggle, opts "Toggle Bookmark")

      map("n", "[c", api.node.navigate.git.prev, opts "Prev Git")
      map("n", "]c", api.node.navigate.git.next, opts "Next Git")
      map("n", "B", api.tree.toggle_no_buffer_filter, opts "Toggle No Buffer")
      map("n", "C", api.tree.toggle_git_clean_filter, opts "Toggle Git Clean")
      map("n", "I", api.tree.toggle_gitignore_filter, opts "Toggle Git Ignore")

      map("n", "]e", api.node.navigate.diagnostics.next, opts "Next Diagnostic")
      map("n", "[e", api.node.navigate.diagnostics.prev, opts "Prev Diagnostic")

      map("n", "F", api.live_filter.clear, opts "Clean Filter")
      map("n", "f", api.live_filter.start, opts "Filter")
    end

    return {
      on_attach = on_attach,
      -- hijack the cursor in the tree to put it at the start of the filename
      hijack_cursor = true,
      disable_netrw = true,
      -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
      -- and refresh the tree
      sync_root_with_cwd = true,
      -- Automatically reloads the tree on `BufEnter` nvim-tree.
      reload_on_bufenter = true,
      -- Will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
      respect_buf_cwd = true,
      -- Use |vim.ui.select| style prompts. Necessary when using a UI prompt decorator
      -- such as dressing.nvim or telescope-ui-select.nvim
      select_prompts = true,
      -- window / buffer setup
      view = {
        -- When entering nvim-tree, reposition the view so that the current node is
        --initially centralized, see |zz|.
        centralize_selection = true,
      },
      -- UI rendering setup
      renderer = {
        -- Appends a trailing slash to folder names.
        add_trailing = true,
        -- Compact folders that only contain a single folder into one node in the file tree.
        --   group_empty = false,
        -- Display node whose name length is wider than the width of nvim-tree window in floating window.
        full_name = true,
        -- Enable file highlight for git attributes using `NvimTreeGit*` highlight groups.
        -- Requires |nvim-tree.git.enable|
        highlight_git = "all",
        -- Enable highlight for diagnostics using `LspDiagnosticsError*Text` highlight groups.
        -- Requires |nvim-tree.diagnostics.enable|
        highlight_diagnostics = "all",
        -- Highlight icons and/or names for |bufloaded()| files using the
        -- NvimTreeOpenedFile highlight group.
        -- See |nvim-tree-api.navigate.opened.next()| and |nvim-tree-api.navigate.opened.prev()|
        -- Value can be "none", "icon", "name" or "all".
        highlight_opened_files = "icon",
        -- Highlight icons and/or names for modified files using the
        -- `NvimTreeModifiedFile` highlight group.
        -- Requires |nvim-tree.modified.enable|
        -- Value can be `"none"`, `"icon"`, `"name"` or `"all"`
        highlight_modified = "icon",
        -- Highlight bookmarked using the NvimTreeBookmarkHL group.
        -- Value can be "none", "icon", "name" or "all"
        highlight_bookmarks = "name",
        -- Enable highlight for clipboard items using the NvimTreeCutHL and
        -- NvimTreeCopiedHL groups.
        -- Value can be "none", "icon", "name" or "all".
        highlight_clipboard = "name",
        -- Configuration options for tree indent markers.
        indent_markers = {
          -- Display indent markers when folders are open
          enable = true,
          -- Display folder arrows in the same column as indent marker
          -- when using |renderer.icons.show.folder_arrow|
          inline_arrows = true,
        },
      },
      -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
      update_focused_file = {
        enable = true,
      },
      -- LSP diagnostics
      diagnostics = {
        enable = true,
      },
      -- Indicate which file have unsaved modification
      modified = {
        -- You will still need to set |renderer.icons.show.modified| `= true` or
        -- |renderer.highlight_modified| `= true` to be able to see modified status in the tree.
        enable = true,
      },
      actions = {
        expand_all = {
          exclude = { ".git", "target", "build", "dist", "__pycache__" },
        },
        -- Configuration options for opening a file from nvim-tree.
        open_file = {
          window_picker = {
            -- If not enabled, files will open in window from which you last opened the tree.
            enable = true,
            picker = function()
              local win_id = require("window-picker").pick_window()
              if win_id == nil then
                vim.cmd "vnew"
                win_id = vim.api.nvim_get_current_win()
                vim.cmd "wincmd p"
                vim.notify("Created a new window " .. win_id)
                vim.notify ""
              end
              return win_id
            end,
          },
        },
      },
      help = {
        sort_by = "desc",
      },
    }
  end,
}

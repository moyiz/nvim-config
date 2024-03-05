return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]parenthen
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      require('mini.statusline').setup()

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
      require('mini.indentscope').setup {
        -- symbol = '|',
        symbol = '▏',
        draw = {
          delay = 30,
        },
        options = {
          try_as_border = true,
        },
      }

      -- Inserts closing character for pairs
      require('mini.pairs').setup {
        modes = {
          command = true,
        },
      }

      --  overview of current buffer text.
      require('mini.map').setup()
      vim.keymap.set('n', '<Leader>mc', require('mini.map').close, { desc = '[C]lose' })
      vim.keymap.set('n', '<Leader>mf', require('mini.map').toggle_focus, { desc = 'Toggle [F]ocus' })
      vim.keymap.set('n', '<Leader>mo', require('mini.map').open, { desc = '[O]pen' })
      vim.keymap.set('n', '<Leader>mr', require('mini.map').refresh, { desc = '[R]efresh' })
      vim.keymap.set('n', '<Leader>ms', require('mini.map').toggle_side, { desc = 'Toggle [S]ide' })
      vim.keymap.set('n', '<Leader>mt', require('mini.map').toggle, { desc = '[T]oggle' })

      -- Highlight word under cursor
      require('mini.cursorword').setup {
        delay = 30,
      }

      -- Easymotion movements
      require('mini.jump2d').setup {
        labels = 'tnresaio',
        view = {
          dim = true,
        },
        mappings = {
          start_jumping = '<leader><cr>',
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

return {
  'norcalli/nvim-colorizer.lua',
  event = 'VeryLazy',
  config = function()
    -- #00f #fff #00f
    require('colorizer').setup { '*' }
    require('colorizer').attach_to_buffer()
  end,
}

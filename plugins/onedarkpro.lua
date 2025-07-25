-- lua/plugins/themes/onedarkpro.lua
return {
  "olimorris/onedarkpro.nvim",
  lazy = false,    -- Load theme immediately
  priority = 1000, -- Set highest priority to ensure it's loaded before all UI plugins
  config = function()
    -- Load Onedark Pro theme
    vim.cmd.colorscheme("onedark")
  end,
}

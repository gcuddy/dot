return {
  "folke/snacks.nvim",
  ---@module 'snacks.nvim'
  ---@type snacks.Config
  opts = {
    picker = {
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        explorer = {
          hidden = true,
          layout = {
            preset = "sidebar",
            preview = { main = true, enabled = false },
          },
        },
      },
    },
    scroll = {
      enabled = false,
    },
    indent = {
      chunk = {
        enabled = true,
      },
    },
    zen = {
      toggles = {
        dim = true,
      },
    },
    styles = {
      zen = {
        backdrop = { transparent = false },
      },
    },
    dashboard = { example = "advanced" },
  },
  keys = {
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Open",
    },
  },
} ---@module 'lazy'

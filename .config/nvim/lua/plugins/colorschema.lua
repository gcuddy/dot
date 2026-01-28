return {
  { "catppuccin/nvim", lazy = true, opts = { flavour = "macchiato", transparent_background = true } },
  { "kvrohit/rasmus.nvim", lazy = true },
  { "p00f/alabaster.nvim" },
  { "olivercederborg/poimandres.nvim", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "yorickpeterse/vim-paper", name = "vim-paper", lazy = true, dev = { true } },
  { "projekt0n/github-nvim-theme", name = "github-theme", lazy = true },
  { "datsfilipe/vesper.nvim", lazy = true, opts = { transparent = true } },
  { "vinitkumar/oscura-vim", lazy = true },
  { "samharju/synthweave.nvim", lazy = true },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
      },
      dim_inactive = false,
      lualine_bold = false,
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = {
      contrast = "hard",
      transparent_mode = true,
    },
  },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 5000,
      set_dark_mode = function()
        vim.o.background = "dark"
        local f = io.open(vim.fn.expand("~/.config/themes/current/nvim-colorscheme"), "r")
        local colorscheme = f and f:read("*l") or "catppuccin"
        if f then f:close() end
        pcall(vim.cmd, "colorscheme " .. colorscheme)
      end,
      set_light_mode = function()
        vim.o.background = "light"
        local f = io.open(vim.fn.expand("~/.config/themes/current/nvim-colorscheme"), "r")
        local colorscheme = f and f:read("*l") or "catppuccin"
        if f then f:close() end
        pcall(vim.cmd, "colorscheme " .. colorscheme)
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

return {
  {
    "catppuccin/nvim",
    opts = {
      flavour = "macchiato",
    },
  },
  {
    "kvrohit/rasmus.nvim",
  },
  {
    "p00f/alabaster.nvim",
  },
  {
    "olivercederborg/poimandres.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("poimandres").setup({
        -- leave this setup function empty for default config
        -- or refer to the configuration section
        -- for configuration options
      })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
  },
  {
    "yorickpeterse/vim-paper",
    name = "vim-paper",
    lazy = true,
    dev = { true },
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
  },
  {
    "datsfilipe/vesper.nvim",
    opts = {
      transparent = true, -- Boolean: Sets the background to transparent
      -- italics = {
      --   comments = false, -- Boolean: Italicizes comments
      --   keywords = false, -- Boolean: Italicizes keywords
      --   functions = false, -- Boolean: Italicizes functions
      --   strings = false, -- Boolean: Italicizes strings
      --   variables = false, -- Boolean: Italicizes variables
      -- },
    },
  },
  {
    "vinitkumar/oscura-vim",
  },
  {
    "samharju/synthweave.nvim",
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- style = "storm",
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
    priority = 1000,
    config = true,
    opts = {
      contrast = "hard",
      transparent_mode = true,
    },
  },
  {
    "f-person/auto-dark-mode.nvim",
    config = function()
      require("auto-dark-mode").setup({
        update_interval = 1000,
        set_dark_mode = function()
          vim.o.background = "dark"
          vim.cmd("colorscheme alabaster")
        end,
        set_light_mode = function()
          vim.o.background = "light"
          vim.cmd("colorscheme alabaster")
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = vim.fn.getenv("ITERM_PROFILE") == "Light" and "ayu" or "tokyonight-moon",
      -- colorscheme = "tokyonight",
      colorscheme = "alabaster",
      -- colorscheme = "vesper",
    },
  },
}

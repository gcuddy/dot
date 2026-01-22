return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      eslint = {
        settings = {
          workingDirectories = { mode = "auto" },
          format = false,
          run = "onSave",
        },
      },
    },
  },
}

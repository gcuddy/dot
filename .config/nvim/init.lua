vim.g.lazyvim_eslint_auto_format = false
if vim.g.vscode then
  vim.o.cmdheight = 50
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

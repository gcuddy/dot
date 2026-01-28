local map = vim.keymap.set

-- Center buffer while navigating
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Quick find/replace in buffer (rip-substitute)
vim.keymap.set({ "n", "x" }, "S", function()
  require("rip-substitute").sub()
end, { desc = "Rip substitute" })

vim.keymap.set("n", "<leader>C", "<cmd>!c %<CR>", { desc = "Open in Cursor" })
-- vim.keymap.set("n", "<leader>C", "<cmd>!c %:" .. vim.fn.line(".") .. "<CR>", { desc = "Open in Cursor" })
-- vim.keymap.set("n", "<leader>C", function()
--   local line = vim.fn.line(".") -- Get the current line number
--   print(line)
--   vim.cmd("!c %:" .. line)
-- end, { desc = "Open in Cursor" })
-- vim.keymap.set("n", "<leader>C", function()
--   local filename = vim.fn.expand("%")
--   local line = vim.fn.getline(".")
--   vim.cmd("!" .. "c " .. vim.fn.shellescape(filename) .. " " .. vim.fn.shellescape(line))
-- end, { desc = "Open in Cursor with Line" })
map("n", "<leader>yr", "<cmd>let @+ = expand('%:~:.')<cr>", { desc = "Relative Path", silent = true })
map("n", "<leader>yf", "<cmd>let @+ = expand('%:p')<cr>", { desc = "Full Path", silent = true })

-- Window resizing
map("n", "<C-Left>", "<C-w><", { desc = "Decrease width" })
map("n", "<C-Right>", "<C-w>>", { desc = "Increase width" })
map("n", "<C-Up>", "<C-w>+", { desc = "Increase height" })
map("n", "<C-Down>", "<C-w>-", { desc = "Decrease height" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })
map("n", "<leader>w|", "<C-w>|", { desc = "Maximize width" })
map("n", "<leader>w_", "<C-w>_", { desc = "Maximize height" })

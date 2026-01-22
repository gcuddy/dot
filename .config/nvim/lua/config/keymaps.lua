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

-- Press 'S' for quick find/replace for the word under the cursor
vim.keymap.set("n", "S", function()
  local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
  local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end)

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

return {
  "dmmulroy/tsc.nvim",
  config = function()
    require("tsc").setup({
      use_trouble_qflist = true,
    })
  end,
  keys = {
    {
      "<leader>tc",
      ":TSC<cr>",
      { desc = "[T]ypeScript [C]ompile" },
    },
  },
}
-- return {
--   {
--     "dmmulroy/tsc.nvim",
--     lazy = true,
--     ft = { "typescript", "typescriptreact" },
--     config = function()
--       require("tsc").setup({
--         enable_error_notifications = true,
--         use_trouble_qflist = true,
--         pretty_errors = true,
--       })
--     end,
--     keys = {
--       {
--         "<leader>tc",
--         ":TSC<cr>",
--         { desc = "[T]ypeScript [C]ompile" },
--       },
--     },
--   },
-- }

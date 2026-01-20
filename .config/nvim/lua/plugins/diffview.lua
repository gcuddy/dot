return {
  "sindrets/diffview.nvim",
  keys = {
    {
      "<leader>gM",
      function()
        require("diffview").open({ "origin/main...", "--imply-local" })
      end,
      desc = "Git Diff against main (diffview)",
    },
  },
}

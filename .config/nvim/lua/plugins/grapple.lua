return {
  {
    "cbochs/grapple.nvim",
    cmd = "Grapple",
    opts = {
      scope = "git_branch",
    },
    keys = function()
      local keys = {
        { "<leader>ha", function() require("grapple").tag() end, desc = "Grapple: Add File" },
        { "<leader>ho", function() require("grapple").toggle_tags() end, desc = "Grapple Open Quick Menu" },
        { "<leader>hr", function() require("grapple").untag() end, desc = "Grapple Remove File" },
        { "<leader>ht", function() require("grapple").toggle() end, desc = "Grapple Toggle" },
        { "<leader>hc", function() require("grapple").reset() end, desc = "Grapple: Reset" },
      }
      for i = 1, 5 do
        table.insert(keys, {
          "<leader>" .. i,
          function() require("grapple").select({ index = i }) end,
          desc = "Grapple to File " .. i,
        })
      end
      return keys
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = {
      lualine_b = { "grapple" },
    },
  },
}

return {
  {
    "cbochs/grapple.nvim",
    cmd = "Grapple",
    opts = {
      scope = "git_branch",
    },
    keys = function()
      -- Note: h key namespace is because I used to use harpoon.
      local keys = {
        {
          "<leader>ha",
          require("grapple").tag,
          desc = "Grapple: Add File",
        },
        {
          "<leader>ho",
          require("grapple").toggle_tags,
          desc = "Grapple Open Quick Menu",
        },
        {
          "<leader>hr",
          require("grapple").untag,
          desc = "Grapple Remove File",
        },
        {
          "<leader>ht",
          require("grapple").toggle,
          desc = "Grapple Open Quick Menu",
        },
        {
          "<leader>hc",
          require("grapple").reset,
          desc = "Grapple: Reset",
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("grapple").select({ index = i })
          end,
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

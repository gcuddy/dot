return {
  {
    "rgroli/other.nvim",
    config = function()
      require("other-nvim").setup({
        mappings = {
          -- Mapping for vitest-style tests
          {
            context = "test",
            pattern = "(.*).ts$",
            target = "%1.(test|stories).ts",
          },
          {
            context = "implementation",
            pattern = "(.*).test.ts$",
            target = "%1.ts",
          },
          {
            context = "story",
            pattern = "(.*).stories.tsx",
            target = "%1.ts",
          },
        },
      })
    end,
    keys = {
      {
        "<leader>fo",
        function()
          require("other-nvim").open()
        end,
        desc = "Open test/spec file",
      },
      -- {
      --   "<leader>oT",
      --   function()
      --     require("other-nvim").openTabNew()
      --   end,
      --   desc = "Tabopen test/spec file",
      -- },
    },
  },
}

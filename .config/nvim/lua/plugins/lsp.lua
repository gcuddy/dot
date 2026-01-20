vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    if vim.bo.ft == "python" then
      vim.lsp.buf.code_action({
        context = { only = { "source.fixAll.ruff" } },
        apply = true,
      })
    end
  end,
})

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      vtsls = {
        settings = {
          typescript = {
            preferences = {
              importModuleSpecifier = "non-relative",
            },
          },
        },
      },
    },
  },
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.opt_local.colorcolumn = ""
	end,
})

return {
	{ "nvim-neo-tree/neo-tree.nvim", enabled = false },

	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>e",
				function()
					require("oil").toggle_float()
				end,
				desc = "Toggle Oil file explorer",
			},
			{ "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
		},
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				columns = {
					"icon",
					"size",
					{ "mtime", highlight = "Comment", format = "%Y-%m-%d %H:%M" },
				},
				confirmation = {
					border = "rounded",
				},
				float = {
					border = "rounded",
					max_width = 120,
				},
				keymaps = {
					["<C-l>"] = false,
					["<C-r>"] = "actions.refresh",
					["q"] = "actions.close",
				},
				view_options = {
					show_hidden = true,
					is_always_hidden = function(name)
						return name == ".DS_Store"
					end,
				},
			})
		end,
	},
}

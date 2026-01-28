return {
	"nvim-mini/mini.files",
	opts = {
		windows = {
			preview = false,
			max_number = math.huge,
			width_focus = 30,
			width_nofocus = 20,
		},
	},
	init = function()
		-- dlvhdr: line numbers in explorer columns
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesWindowUpdate",
			callback = function(args)
				vim.wo[args.data.win_id].number = true
				vim.wo[args.data.win_id].relativenumber = true
			end,
		})
	end,
	config = function(_, opts)
		require("mini.files").setup(opts)

		-- LazyVim defaults: toggle dotfiles, splits, set cwd, LSP rename
		-- (from lazyvim.plugins.extras.editor.mini-files)

		local show_dotfiles = true
		local filter_show = function()
			return true
		end
		local filter_hide = function(fs_entry)
			return not vim.startswith(fs_entry.name, ".")
		end

		local toggle_dotfiles = function()
			show_dotfiles = not show_dotfiles
			local new_filter = show_dotfiles and filter_show or filter_hide
			require("mini.files").refresh({ content = { filter = new_filter } })
		end

		local map_split = function(buf_id, lhs, direction, close_on_file)
			local rhs = function()
				local cur_target_window = require("mini.files").get_explorer_state().target_window
				if cur_target_window ~= nil then
					local new_target_window
					vim.api.nvim_win_call(cur_target_window, function()
						vim.cmd("belowright " .. direction .. " split")
						new_target_window = vim.api.nvim_get_current_win()
					end)
					require("mini.files").set_target_window(new_target_window)
					require("mini.files").go_in({ close_on_file = close_on_file })
				end
			end
			vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = "Open in " .. direction .. " split" })
		end

		local files_set_cwd = function()
			local cur_entry_path = MiniFiles.get_fs_entry().path
			local cur_directory = vim.fs.dirname(cur_entry_path)
			if cur_directory ~= nil then
				vim.fn.chdir(cur_directory)
			end
		end

		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesBufferCreate",
			callback = function(args)
				local buf_id = args.data.buf_id
				vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden files" })
				vim.keymap.set("n", "gc", files_set_cwd, { buffer = buf_id, desc = "Set cwd" })
				vim.keymap.set("n", "q", require("mini.files").close, { buffer = buf_id, desc = "Close" })
				vim.keymap.set("n", "-", require("mini.files").go_out, { buffer = buf_id, desc = "Go to parent" })
				vim.keymap.set("n", "<CR>", function()
					require("mini.files").go_in({ close_on_file = true })
				end, { buffer = buf_id, desc = "Open file/dir" })
				map_split(buf_id, "<C-w>s", "horizontal", false)
				map_split(buf_id, "<C-w>v", "vertical", false)
				map_split(buf_id, "<C-w>S", "horizontal", true)
				map_split(buf_id, "<C-w>V", "vertical", true)
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesActionRename",
			callback = function(event)
				Snacks.rename.on_rename_file(event.data.from, event.data.to)
			end,
		})

		-- dlvhdr: auto-delete buffers for deleted files
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesActionDelete",
			callback = function(event)
				local bufnr = vim.fn.bufnr(event.data.from)
				if bufnr ~= -1 then
					vim.api.nvim_buf_delete(bufnr, { force = true })
				end
			end,
		})
	end,
	keys = {
		{
			"<leader>fm",
			function()
				local MiniFiles = require("mini.files")
				if not MiniFiles.close() then
					MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
				end
			end,
			desc = "Mini Files (toggle)",
		},
		{
			"<leader>fM",
			function()
				require("mini.files").open(vim.uv.cwd(), true)
			end,
			desc = "Mini Files (cwd)",
		},
	},
}

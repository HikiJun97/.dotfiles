-- lua/plugins/telescope.lua

return {
	{
		"nvim-telescope/telescope.nvim",
		keys = function()
			local builtin = require("telescope.builtin")
			return {
				{ "<leader>ff", builtin.find_files, desc = "Find files" },
				{ "<leader>fg", builtin.live_grep, desc = "Live grep" },
				{ "<leader>fb", builtin.buffers, desc = "Find buffers" },
				{ "<leader>fh", builtin.help_tags, desc = "Help tags" },
			}
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		opts = {
			extensions = {
				file_browser = {
					theme = "ivy",
					hijack_netrw = false,
				},
			},
		},
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function() end,
	},
}
